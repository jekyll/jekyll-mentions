# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "jekyll-mentions"
  s.summary     = "@mention support for your Jekyll site"
  s.version     = "1.2.0"
  s.authors     = ["GitHub, Inc."]
  s.email       = "support@github.com"

  s.homepage    = "https://github.com/jekyll/jekyll-mentions"
  s.licenses    = ["MIT"]
  s.files       = [ "lib/jekyll-mentions.rb" ]

  s.add_dependency "activesupport", "~> 4.0"
  s.add_dependency "html-pipeline", "~> 2.3"
  s.add_dependency "jekyll", "~> 3.0"

  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop", "~> 0.48"
end
