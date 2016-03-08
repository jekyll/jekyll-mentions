require 'spec_helper'

RSpec.describe(Jekyll::Mentions) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) { {} }
  let(:configs) do
    Jekyll.configuration(config_overrides.merge({
      'skip_config_files' => false,
      'collections'       => { 'docs' => { 'output' => true } },
      'source'            => fixtures_dir,
      'destination'       => fixtures_dir('_site')
    }))
  end
  let(:mentions)    { described_class }
  let(:default_src) { "https://github.com" }
  let(:site)        { Jekyll::Site.new(configs) }
  let(:result)      { "test <a href=\"https://github.com/test\" class=\"user-mention\">@test</a> test" }

  let(:posts)        { site.posts.docs.sort.reverse }
  let(:basic_post)   { posts[1] }
  let(:complex_post) { posts[0] }

  def para(content)
    "<p>#{content}</p>\n"
  end

  before(:each) do
    site.reset
    site.read
    (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
    site.render
  end

  it "creates a filter" do
    expect(mentions.filters[default_src]).to be_a(HTML::Pipeline)
  end

  it "has a default source" do
    expect(mentions.mention_base).to eql(default_src)
  end

  it "correctly replaces the mentions with the img in posts" do
    expect(basic_post.title).to eql("I'm a post")
    expect(basic_post.output).to eql(para(result))
  end

  it "doesn't replace mentions in a code block" do
    expect(complex_post.title).to eql("Code Block")
    expect(complex_post.output).to include(
      "<span class=\"s2\">\"test @test test\"</span>"
    )
    expect(complex_post.output).to include(result)
  end

  it "correctly replaces the mentions with the img in pages" do
    expect(site.pages.first.output).to eql(para(result))
  end

  it "correctly replaces the mentions with the img in collection documents" do
    expect(site.collections["docs"].docs.first.output).to eql(para(result))
  end

  it "does not mangle liquid templates" do
    expect(site.collections["docs"].docs.last.output).to eql(
      para("#{result} <a href=\"/docs/with_liquid.html\">_docs/with_liquid.md</a>")
    )
  end

  context "with a different base for jmentions" do
    let(:mentions_src) { "http://mine.club" }
    let(:config_overrides) do
      {
        "jekyll-mentions" => { "base_url" => mentions_src }
      }
    end

    it "fetches the custom base from the config" do
      expect(mentions.mention_base(site.config)).to eql(mentions_src)
    end

    it "respects the new base when mentionsfying" do
      expect(basic_post.output).to eql(para(result.sub(default_src, mentions_src)))
    end
  end
end
