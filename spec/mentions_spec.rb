# frozen_string_literal: true

RSpec.describe(Jekyll::Mentions) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) { {} }
  let(:configs) do
    Jekyll.configuration(
      config_overrides.merge(
        "skip_config_files" => false,
        "collections"       => { "docs" => { "output" => true } },
        "source"            => fixtures_dir,
        "destination"       => fixtures_dir("_site")
      )
    )
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
  let(:spl_chars_doc) { find_by_title(site.collections["docs"].docs, "Unconventional Names") }
  let(:index_page) { find_by_title(site.pages, "I'm a page") }
  let(:minified_page) { find_by_title(site.pages, "I'm minified!") }
  let(:disabled_mentioning_page) { find_by_title(site.pages, "ignore all mentions") }
  let(:custom_url_01) { find_by_title(site.pages, "custom URL 01") }
  let(:custom_url_02) { find_by_title(site.pages, "custom URL 02") }

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
    expect(index_page.output).to include(para(result))
  end

  it "correctly replaces the mentions with the link in minified pages" do
    expect(minified_page.output).to include(para(result))
  end

  it "doesn't mangle layouts" do
    expect(index_page.output).to include("<html lang=\"en-US\">")
    expect(index_page.output).to include("<body class=\"wrap\">\n")
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

  it "works with HTML body tag markup across multiple lines" do
    expect(find_by_title(site.pages, "Multi-line Body Tag").output).to include(para(result))
  end

  context "when jekyll-mentions is set to false" do
    it "should not replace the @TestUser with the link to @TestUser" do
      expect(disabled_mentioning_page.output).not_to include(result)
    end

    it "should leave other pages in the site alone and mention as normal" do
      expect(index_page.output).to include(result)
    end
  end

  context "when the jekyll-mentions is overridden on a single file" do
    let(:custom_url_result) do
      "<a href=\"https://custom-url.com/TestUser\" class=\"user-mention\">@TestUser</a>"
    end

    context "when overriden in pattern 'jekyll-mentions: custom_url'" do
      it "should replace the mentions with the link in that specific file" do
        expect(custom_url_01.output).to include(custom_url_result)
      end

      it "should not include the default URL" do
        expect(custom_url_01.output).not_to include(result)
      end

      it "should leave other pages in the site alone and mention as normal" do
        expect(index_page.output).to include(result)
      end
    end

    context "when overriden in pattern 'jekyll-mentions.base_url: custom_url'" do
      it "should replace the mentions with the link in that specific file" do
        expect(custom_url_02.output).to include(custom_url_result)
      end

      it "should not include the default URL" do
        expect(custom_url_02.output).not_to include(result)
      end

      it "should leave other pages in the site alone and mention as normal" do
        expect(index_page.output).to include(result)
      end
    end
  end

  context "with non-word characters" do
    it "does not render when there's a leading hyphen" do
      expect(spl_chars_doc.output).to start_with(para("Howdy @-pardner!"))
    end

    it "renders fine when there's a non-leading hyphen" do
      expect(spl_chars_doc.output).to include(
        para(
          "<a href=\"https://github.com/haTTric-\" class=\"user-mention\">@haTTric-</a> sez you are quite " \
          "the <a href=\"https://github.com/task-master\" class=\"user-mention\">@task-master</a>.."
        )
      )
    end

    it "renders fine when there's an underscore" do
      expect(spl_chars_doc.output).to include(
        para(
          "Checkout <a href=\"https://github.com/Casino_Royale\" class=\"user-mention\">@Casino_Royale</a>"
        )
      )
      expect(spl_chars_doc.output).to include(
        para(
          "The Original <a href=\"https://github.com/_Bat_Cave\" class=\"user-mention\">@_Bat_Cave</a>"
        )
      )
    end
  end

  context "with a different base for jmentions" do
    let(:mentions_src) { "https://twitter.com" }
    let(:config_overrides) do
      {
        "jekyll-mentions" => { "base_url" => mentions_src },
      }
    end

    it "fetches the custom base from the config" do
      expect(mentions.mention_base(site.config)).to eql(mentions_src)
    end

    it "respects the new base when mentionifying" do
      expect(basic_post.output).to start_with(para(result.sub(default_src, mentions_src)))
    end
  end

  context "when the different base is defined in the front matter of the doc" do
    let(:mentions_src) { "https://twitter.com" }
    let(:doc_overrides) do
      {
        "jekyll-mentions" => { "base_url" => mentions_src },
      }
    end
    let(:config_overrides) do
      {
        "jekyll-mentions" => { "base_url" => default_src },
      }
    end

    it "fetches the custom base from the config" do
      effective_overrides = site.config.merge(doc_overrides)
      expect(mentions.mention_base(effective_overrides)).to eql(mentions_src)
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
