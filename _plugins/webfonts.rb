require 'open3'

# A static file copied from outside the site source (the Nix store)
class WebfontFile < Jekyll::StaticFile
  def initialize(site, source, dir)
    super(site, site.source, dir, File.basename(source))
    @source = source
  end

  def path
    @source
  end
end

class WebfontsGenerator < Jekyll::Generator
  def generate(site)
    Jekyll.logger.info "Fonts:", "Building"
    out, err, status = Open3.capture3 "nix-build", "_plugins/webfonts.nix", "--no-out-link"
    raise "nix-build failed: #{err}" unless status.success?
    result = out.strip
    # Serve fonts under the store path hash so their URLs can be cached forever
    dir = "fonts/#{File.basename(result).split("-").first}"
    Dir["#{result}/WOFF2/*"].each do |f|
      site.static_files << WebfontFile.new(site, f, dir)
    end
    # Font CSS for stylesheets/stylesheet.css to include
    site.data["webfonts_css"] = Dir["#{result}/*.css"].sort.map do |f|
      File.read(f).gsub("url('WOFF2/", "url('../#{dir}/")
    end.join
  end
end
