require 'jekyll'
require 'html/pipeline'

module Jekyll
  class Mentions < Jekyll::Generator

    TAG = "jekyll_mentions"
    URL = "https://github.com"

    def generate(site)
      site.pages.each { |page| mentionify page }
      site.posts.each { |page| mentionify page }
    end

    def mentionify(page)
      filter = HTML::Pipeline::MentionFilter.new("<#{TAG}>#{page.content}</#{TAG}>", { :base_url => URL })
      page.content = filter.call.search(TAG).children.to_xml
    end

  end
end
