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
      filter = HTML::Pipeline::MentionFilter.new(nil, {:base_url => URL })
      page.content = filter.mention_link_filter(page.content)
    end
  end
end
