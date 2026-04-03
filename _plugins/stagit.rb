require 'fileutils'
require 'nokogiri'

def wrap_stagit_output path, header
  doc = Nokogiri::HTML(File.read(path))

  ## Change git repo name from h1 to h2
  h = doc.at("h1")
  h.name = "h2"
  h.content = "#{h.content}.git"

  ## Put the git repo name, clone URL, and stagit navigation into a container
  nav_section = doc.create_element "section", class: "container wide git" do |e|
    e.add_child h
    e.add_child doc.at(".url")
    e.add_child doc.at("nav")
  end

  ## Put the stagit main body into another container
  main_section = doc.create_element "main", class: "container wide git" do |e|
    e.add_child doc.at("main").children
    e.css("h2").each { |h| h.name = "h3" }
  end

  body = doc.at("body")
  body.children.remove
  body << header << nav_section << main_section

  ## Fix the stylesheet and add dummy favion like _layouts/default.md
  stylesheet = doc.at_css('link[rel="stylesheet"]')
  stylesheet["href"] = "/stylesheets/stylesheet.css"
  stylesheet["media"] = "screen"
  doc.at("head").add_child '<link rel="icon" href="data:image/png;base64,iVBORw0KGgo=">'

  ## Add some nicer markup in commit messages
  doc.xpath("//pre[b[normalize-space()='commit' and not(preceding-sibling::node())]]//text()").each do |text_node|
    html = text_node.content
    ## Turn issue references into links
    html = html.gsub(/(?<=^|\s)#(\d+)\b/) do |match|
      "<a href=\"https://github.com/sup-heliotrope/sup/issues/#{$1}\">#{$&}</a>"
    end
    ## Turn commit references into links
    html = html.gsub(/(?<=[Cc]ommit )([0-9a-f]+)\b/) do |match|
      href = Dir.new(File.dirname(path)).each_child.find { |fn| fn.start_with? $& }
      next $& if href.nil?
      "<a href=\"#{href}\">#{$&}</a>"
    end
    text_node.replace html
  end

  File.write(path, doc.to_html)
end

Jekyll::Hooks.register :site, :post_write do |site|
  header = File.read "#{site.source}/_includes/header.html"
  %w[sup sup-colors sup-website].each do |repo|
    dest = "#{site.dest}/git/#{repo}"
    Jekyll.logger.info "Stagit:", "Processing #{repo}"

    FileUtils.mkdir_p dest
    system "cd #{dest} && stagit -u https://supmua.dev/git/#{repo}/ /home/dan/src/#{repo}" or raise "stagit failed"

    ## Munge stagit generate files to fit the rest of the site
    Dir.glob "#{dest}/**/*.html", File::FNM_DOTMATCH do |path|
      wrap_stagit_output path, header unless path.include? "/raw/"
    end
  end
end
