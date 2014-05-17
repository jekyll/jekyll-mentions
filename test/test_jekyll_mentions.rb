require 'helper'

class TestJekyllMentions < Minitest::Test
  include MentionsTestHelpers

  def setup
    @site = fixture_site
    @site.read
    @mentions = Jekyll::Mentions.new(@site)
    @mention = "test <a href='https://github.com/test' class='user-mention'>@test</a> test"
  end

  should "replace @mention with link" do
    page = page_with_name(@site, "index.md")

    @mentions.mentionify page
    assert_equal @mention, page.content
  end

  should "replace page content on generate" do
    @mentions.generate(@site)
    assert_equal @mention, @site.pages.first.content
  end

  should "not mangle liquid templating" do
    page = page_with_name(@site, "leave-liquid-alone.md")

    @mentions.mentionify page
    assert_equal "#{@mention}<a href=\"{{ test }}\">test</a>", page.content
  end

  should "not mangle markdown" do
    page = page_with_name(@site, "mentioned-markdown.md")

    @mentions.mentionify page
    assert_equal "#{@mention}\n> test", page.content
  end

  should "not mangle non-mentioned content" do
    page = page_with_name(@site, "non-mentioned.md")

    @mentions.mentionify page
    assert_equal "test test test\n> test", page.content
  end

  should "not touch non-HTML pages" do
    @mentions.generate(@site)
    assert_equal "test @test test", page_with_name(@site, "test.json").content
  end

end
