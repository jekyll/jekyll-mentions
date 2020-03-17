# frozen_string_literal: true

require_relative "lib/jekyll-mentions/version"

Gem::Specification.new do |s|
  s.name        = "jekyll-mentions"
  s.summary     = "@mention support for your Jekyll site"
  s.version     = JekyllMentions::VERSION
  s.authors     = ["GitHub, Inc."]
  s.email       = "support@github.com"

  s.homepage    = "https://github.com/jekyll/jekyll-mentions"
  s.licenses    = ["MIT"]
  s.files       = ["lib/jekyll-mentions.rb"]

  s.required_ruby_version = ">= 2.4.0"

  s.add_dependency "html-pipeline", "~> 2.3"
  s.add_dependency "jekyll", ">= 3.7", "< 5.0"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake", "~> 12.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop-jekyll", "~> 0.4"
end
