Gem::Specification.new do |s|
  s.name = "jekyll-mentions"
  s.summary = "@mention support for your Jekyll site"
  s.version = "0.0.8"
  s.authors = ["GitHub, Inc."]
  s.email = "support@github.com"
  s.homepage = "https://github.com/jekyll/jekyll-mentions"
  s.licenses = ["MIT"]
  s.files = [ "lib/jekyll-mentions.rb" ]
  s.add_dependency( "jekyll", '~> 1.4')
  s.add_dependency( "html-pipeline", '~> 1.5.0' )
end
