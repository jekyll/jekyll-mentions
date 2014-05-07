require 'helper'

class TestJekyllMentions < Minitest::Test

  def setup
    @site = Jekyll::Site.new(Jekyll::Configuration::DEFAULTS)
    @mentions = Jekyll::Mentions.new(@site)
    @page = Jekyll::Page.new(@site, File.expand_path("../../", __FILE__), "", "README.md")
    @page.instance_variable_set "@content", "test @test test"
    @site.pages.push @page
    @mention = "test <a href='https://github.com/test' class='user-mention'>@test</a> test"
  end

  should "replace @mention with link" do
    @mentions.mentionify @page
    assert_equal @mention, @page.content
  end

  should "replace page content on generate" do
    @mentions.generate(@site)
    assert_equal @mention, @site.pages.first.content
  end

  should "not mangle liquid templating" do
    page = Jekyll::Page.new(@site, File.expand_path("../../", __FILE__), "", "README.md")
    page.instance_variable_set "@content", 'test @test test<a href="{{ test }}">test</a>'

    @mentions.mentionify page
    assert_equal "#{@mention}<a href=\"{{ test }}\">test</a>", page.content
  end

  should "not mangle markdown" do
    page = Jekyll::Page.new(@site, File.expand_path("../../", __FILE__), "", "README.md")
    page.instance_variable_set "@content", "test @test test\n> test"

    @mentions.mentionify page
    assert_equal "#{@mention}\n> test", page.content
  end

  should "not mangle non-mentioned content" do
    page = Jekyll::Page.new(@site, File.expand_path("../../", __FILE__), "", "README.md")
    page.instance_variable_set "@content", "test test test\n> test"

    @mentions.mentionify page
    assert_equal "test test test\n> test", page.content
  end

end
