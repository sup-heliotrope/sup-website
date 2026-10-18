require 'fileutils'
require 'open3'

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll.logger.info "Fonts:", "Building"
  out, err, status = Open3.capture3 "nix-build", "_plugins/webfonts.nix", "--no-out-link"
  raise "nix-build failed: #{err}" unless status.success?
  result = out.strip
  FileUtils.mkdir_p "#{site.dest}/fonts"
  Dir["#{result}/*.css"].each { |f| FileUtils.cp f, "#{site.dest}/fonts" }
  FileUtils.mkdir_p "#{site.dest}/fonts/WOFF2"
  Dir["#{result}/WOFF2/*"].each { |f| FileUtils.cp f, "#{site.dest}/fonts/WOFF2" }
end
