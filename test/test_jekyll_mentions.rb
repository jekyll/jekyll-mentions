require 'helper'

class TestJekyllMentions < Minitest::Test
  include MentionsTestHelpers

  def setup
    @site = fixture_site
    @site.read
    @mentions = Jekyll::Mentions.new(@site.config)
    @mention = "test <a href='https://github.com/TestUser' class='user-mention'>@TestUser</a> test"
  end

  should "replace @mention with link" do
    page = page_with_name(@site, "index.md")

    @mentions.mentionify page
    assert_equal @mention, page.content
  end

  should "replace @mention with link in collections" do
    page = document("file.md")

    @mentions.mentionify page
    assert_equal @mention, page.content
  end

  context "generating" do
    should "replace page content on generate" do
      @mentions.generate(@site)
      assert_equal @mention, @site.pages.first.content
    end

    should "replace post content on generate" do
      @mentions.generate(@site)
      assert_equal @mention, @site.posts.docs.first.content.strip
    end

    should "replace doc content on generate" do
      @mentions.generate(@site)
      assert_equal @mention, @site.collections["docs"].docs.first.content
    end
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

  should "also convert pages with permalinks ending in /" do
    page = page_with_name(@site, "parkr.txt")

    @mentions.mentionify page
    assert_equal "Parker \"<a href='https://github.com/parkr' class='user-mention'>@parkr</a>\" Moore", page.content
  end

  context "with special base URL specified" do
    def setup
      @site = fixture_site
      @site.read
      @site.config['jekyll-mentions'] = {"base_url" => "https://twitter.com"}
      @mentions = Jekyll::Mentions.new(@site.config)
      @mention = "test <a href='https://twitter.com/test' class='user-mention'>@test</a> test"
    end

    should "convert when hash setting" do
      page = page_with_name(@site, "index.md")

      @mentions.mentionify page
      assert_equal @mention, page.content
    end
  end

  context "reading custom base urls" do
    def setup
      @mentions = Jekyll::Mentions.new(Hash.new)
    end

    should "handle a raw string" do
      assert_equal "https://twitter.com", @mentions.base_url("https://twitter.com")
    end

    should "handle a hash config" do
      assert_equal "https://twitter.com", @mentions.base_url({"base_url" => "https://twitter.com"})
    end

    should "default to github.com if not there" do
      assert_equal "https://github.com", @mentions.base_url(nil)
    end
  end

end
