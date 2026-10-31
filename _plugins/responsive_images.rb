require 'cgi'
require 'open3'

def run_command *args
  out, err, status = Open3.capture3 *args
  raise "#{args.first} failed: #{err}" unless status.success?
  out
end

class ResizedImage < Jekyll::StaticFile
  def initialize site, dir, name, source, width
    super site, site.source, dir, name
    @source = source
    @width = width
  end

  def path
    @source
  end

  def write dest
    dest_path = destination dest
    Jekyll.logger.info "Resizing:", dest_path
    FileUtils.mkdir_p File.dirname(dest_path)
    run_command "magick", @source, "-resize", "#{@width}x", dest_path
    run_command "pngquant", "--nofs", "--strip", "--force", "--output", dest_path, "32", dest_path
    run_command "oxipng", "--quiet", "--opt", "2", "--strip", "all", dest_path
    true
  end
end

$responsive_images = {}
Jekyll::Hooks.register :site, :after_reset do |site|
  $responsive_images = {}
end

class ResponsiveImageTag < Liquid::Tag
  def initialize tag_name, markup, tokens
    super
    @src = markup.split.first
    @attributes = {}
    markup.scan(Liquid::TagAttributes) do |key, value|
      @attributes[key] = Liquid::Expression.parse value
    end
  end

  def render context
    site = context.registers[:site]
    page = context.registers[:page]
    site_path = @src.start_with?("/") ? @src : File.join(page["dir"], @src)
    image = $responsive_images[site_path] ||= add_image site, site_path

    ext = File.extname @src
    base = @src.delete_suffix ext
    srcset = image[:widths].map { |w| "#{base}-#{w}w#{ext} #{w}w" }
    srcset << "#{@src} #{image[:width]}w"
    attrs = %(src="#{@src}" width="#{image[:width]}" height="#{image[:height]}" srcset="#{srcset.join(", ")}")
    alt = context.evaluate @attributes["alt"]
    attrs << %( alt="#{CGI.escapeHTML alt.to_s}") unless alt.nil?
    attrs << (context.evaluate(@attributes["lazy"]) ? %( loading="lazy" sizes="auto, 100vw") : %( sizes="100vw"))
    "<img #{attrs}>"
  end

  private

  def add_image site, site_path
    source = File.join site.source, site_path
    raise "responsive_img: #{source} not found" unless File.exist? source
    width, height = run_command("magick", "identify", "-format", "%w %h", source).split.map(&:to_i)
    dir = File.dirname site_path
    ext = File.extname site_path
    basename = File.basename site_path, ext
    widths = [2, 4].map { |d| width / d }
    widths.each do |w|
      site.static_files << ResizedImage.new(site, dir, "#{basename}-#{w}w#{ext}", source, w)
    end
    { width: width, height: height, widths: widths }
  end
end

Liquid::Template.register_tag("responsive_img", ResponsiveImageTag)
