require 'jekyll'
require 'html/pipeline'

module Jekyll
  class Mentions < Jekyll::Converter
    MENTIONABLE_EXTS = %w{.html .htm .md .markdown .mkdn .mkd .textile}

    safe true
    priority :low

    attr_reader :filter

    DEFAULT_URL = "https://github.com"

    def initialize(config = Hash.new)
      @filter = HTML::Pipeline::MentionFilter.new(nil, {
        :base_url => base_url(config['jekyll-mentions'])
      })
    end

    def matches(ext)
      MENTIONABLE_EXTS.include?(ext.downcase)
    end

    def output_ext(*)
      ".html".freeze
    end

    def convert(content)
      if content.include?('@')
        filter.mention_link_filter(content)
      else
        content
      end
    end

    def base_url(configs)
      case configs
      when nil, NilClass
        DEFAULT_URL
      when String
        configs.to_s
      when Hash
        configs.fetch('base_url', DEFAULT_URL)
      else
        raise ArgumentError.new("Your jekyll-mentions config has to either be a string or a hash! It's a #{configs.class} right now.")
      end
    end
  end
end
