RSpec.describe(Jekyll::Mentions) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) { {} }
  let(:configs) do
    Jekyll.configuration(config_overrides.merge({
      "skip_config_files" => false,
      "collections"       => { "docs" => { "output" => true } },
      "source"            => fixtures_dir,
      "destination"       => fixtures_dir("_site"),
    }))
  end
  let(:mentions)    { described_class }
  let(:default_src) { "https://github.com" }
  let(:site)        { Jekyll::Site.new(configs) }
  let(:unrendered)  { "test @TestUser test" }
  let(:result)      { "test <a href=\"https://github.com/TestUser\" class=\"user-mention\">@TestUser</a> test" }

  let(:posts)        { site.posts.docs.sort.reverse }
  let(:basic_post)   { find_by_title(posts, "I'm a post") }
  let(:complex_post) { find_by_title(posts, "Code Block") }

  let(:basic_doc) { find_by_title(site.collections["docs"].docs, "File") }
  let(:doc_with_liquid) { find_by_title(site.collections["docs"].docs, "With Liquid") }
  let(:txt_doc) { find_by_title(site.collections["docs"].docs, "Don't Touch Me") }

  def para(content)
    "<p>#{content}</p>"
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
    expect(basic_post.output).to start_with(para(result))
  end

  it "doesn't replace mentions in a code block" do
    expect(complex_post.output).to include(
      "<span class=\"s2\">\"test @TestUser test\"</span>"
    )
    expect(complex_post.output).to include(result)
  end

  it "correctly replaces the mentions with the link in pages" do
    expect(site.pages.first.output).to include(para(result))
  end

  it "doesn't mangle layouts" do
    expect(site.pages.first.output).to include("<html lang=\"en-US\">")
    expect(site.pages.first.output).to include("<body class=\"wrap\">\n")
  end

  it "correctly replaces the mentions with the link in collection documents" do
    expect(basic_doc.output).to start_with(para(result))
  end

  it "leaves non-HTML files alone" do
    expect(txt_doc.output).to start_with(unrendered)
  end

  it "does not mangle liquid templates" do
    expect(doc_with_liquid.output).to start_with(
      para("#{result} <a href=\"/docs/with_liquid.html\">_docs/with_liquid.md</a>")
    )
  end

  context "with a different base for jmentions" do
    let(:mentions_src) { "http://mine.club" }
    let(:config_overrides) do
      {
        "jekyll-mentions" => { "base_url" => mentions_src },
      }
    end

    it "fetches the custom base from the config" do
      expect(mentions.mention_base(site.config)).to eql(mentions_src)
    end

    it "respects the new base when mentionsfying" do
      expect(basic_post.output).to start_with(para(result.sub(default_src, mentions_src)))
    end
  end

  context "with the SSL and GITHUB_HOSTNAME environment variables set" do
    let(:ssl)                  { "true" }
    let(:github_hostname)      { "github.vm" }
    let(:default_mention_base) { "https://github.vm" }

    before(:each) do
      ENV["SSL"] = ssl
      ENV["GITHUB_HOSTNAME"] = github_hostname
    end

    after(:each) do
      ENV.delete("SSL")
      ENV.delete("GITHUB_HOSTNAME")
    end

    it "has a default source based on SSL and GITHUB_HOSTNAME" do
      expect(mentions.mention_base).to eql(default_mention_base)
    end

    it "uses correct mention URLs when SSL and GITHUB_HOSTNAME are set" do
      # Re-render the site, so that ENV is used
      site.render
      expect(basic_post.output).to start_with(para(result.sub(default_src, default_mention_base)))
    end

    it "falls back to using the default if SSL is empty" do
      ENV["SSL"] = ""
      expect(mentions.mention_base).to eql(default_src)
    end

    it "falls back to using the default if GITHUB_HOSTNAME is empty" do
      ENV["GITHUB_HOSTNAME"] = ""
      expect(mentions.mention_base).to eql(default_src)
    end
  end
end
