Gem::Specification.new do |s|
  s.name = "jekyll-mentions"
  s.summary = "@mentionable support for your Jekyll site"
  s.description = ""
  s.version = "0.0.2"
  s.authors = ["GitHub, Inc."]
  s.email = "support@github.com"
  s.homepage = "https://github.com/github/jemoji"
  s.licenses = ["MIT"]
  s.files = [ "lib/jekyll-mentions.rb" ]
  s.add_dependency( "jekyll" )
  s.add_dependency( "html-pipeline" )
end
