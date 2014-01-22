require 'jekyll'
require 'html/pipeline'

module Jekyll
  class Mentions < Jekyll::Generator

    safe true

    TAG = "jekyll_mentions"
    URL = "https://github.com"

    def generate(site)
      site.pages.each { |page| mentionify page }
      site.posts.each { |page| mentionify page }
    end

    def mentionify(page)
      filter = HTML::Pipeline::MentionFilter.new(page.content, { :base_url => URL })
      page.content = filter.call
    end

  end
end

module HTML
  class Pipeline
    class MentionFilter < Filter
      def call
        if html.include?('@')
          mention_link_filter(html, base_url, info_url)
        else
          html
        end
      end
    end
  end
end
