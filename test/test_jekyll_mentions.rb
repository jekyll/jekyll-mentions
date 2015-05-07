require 'helper'

class TestJekyllMentions < Minitest::Test
  include MentionsTestHelpers

  def setup
    @site = fixture_site
    @site.read
    @mentions = if @site.respond_to?(:find_converter_instance)
      @site.find_converter_instance(Jekyll::Mentions)
    else
      @site.getConverterImpl(Jekyll::Mentions)
    end
    @site.render
    @mention = "test <a href='https://github.com/test' class='user-mention'>@test</a> test"
    @mentions_paragraph = "<p>#{@mention}</p>\n"
  end

  should "replace @mention with link" do
    page = page_with_name(@site, "index.md")
    assert_equal @mentions_paragraph, page.content
  end

  should "replace @mention with link in collections" do
    page = document("file.md")
    assert_equal @mentions_paragraph, page.content
  end

  should "replace page content on generate" do
    assert_equal @mentions_paragraph, @site.pages.first.content
  end

  should "not mangle liquid templating" do
    page = page_with_name(@site, "leave-liquid-alone.md")
    assert_equal "<p>#{@mention}<a href=\"some_asinine_value\">test</a></p>\n", page.content
  end

  should "not mangle markdown" do
    page = page_with_name(@site, "mentioned-markdown.md")
    assert_equal "<p>#{@mention}\n&gt; test</p>\n", page.content
  end

  should "not mangle non-mentioned content" do
    page = page_with_name(@site, "non-mentioned.md")
    assert_equal "<p>test test test\n&gt; test</p>\n", page.content
  end

  should "not touch non-HTML pages" do
    assert_equal "test @test test", page_with_name(@site, "test.json").content
  end

  context "with special base URL specified" do
    def setup
      @site = fixture_site('jekyll-mentions' => {'base_url' => 'https://twitter.com'})
      @site.read
      @site.render
      @mention = "test <a href='https://twitter.com/test' class='user-mention'>@test</a> test"
    end

    should "convert when hash setting" do
      page = page_with_name(@site, "index.md")
      assert_equal "<p>#{@mention}</p>\n", page.content
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
