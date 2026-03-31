require 'fileutils'
require 'nokogiri'

Jekyll::Hooks.register :site, :post_write do |site|
  header = File.read "#{site.source}/_includes/header.html"
  %w[sup sup-colors sup-website].each do |repo|
    dest = "#{site.dest}/git/#{repo}"
    Jekyll.logger.info "Stagit:", "Processing #{repo}"
    FileUtils.mkdir_p dest
    system "cd #{dest} && stagit -u https://supmua.dev/git/#{repo}/ /home/dan/src/#{repo}" or raise "stagit failed"
    ## Munge stagit generate files to fit the rest of the site
    Dir.glob "#{dest}/**/*.html", File::FNM_DOTMATCH do |path|
      next if path.include? "/raw/"
      doc = Nokogiri::HTML(File.read(path))
      body = doc.at("body")
      h = doc.at("h1")
      h.name = "h2"
      h.content = "# #{h.content}.git"
      nav_section = doc.create_element "section", class: "container wide git" do |e|
        e.add_child h
        e.add_child doc.at(".url")
        e.add_child doc.at("nav")
      end
      main_section = doc.create_element "main", class: "container wide git" do |e|
        e.add_child doc.at("main").children
        e.css("h2").each { |h| h.name = "h3" }
      end
      body.children.remove
      body.add_child header
      body.add_child nav_section
      body.add_child main_section
      stylesheet = doc.at_css('link[rel="stylesheet"]')
      stylesheet["href"] = "/stylesheets/stylesheet.css"
      stylesheet["media"] = "screen"
      doc.at("head").add_child '<link rel="icon" href="data:image/png;base64,iVBORw0KGgo=">'
      File.write(path, doc.to_html)
    end
  end
end
