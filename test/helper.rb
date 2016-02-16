require 'rubygems'
require 'minitest/autorun'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jekyll-mentions'

TEST_DIR     = File.expand_path("../", __FILE__)
FIXTURES_DIR = File.expand_path("fixtures", TEST_DIR)
DEST_DIR     = File.expand_path("../tmp/destination", TEST_DIR)

module MentionsTestHelpers
  def config
    @config ||= Jekyll.configuration({
      "source" => FIXTURES_DIR,
      "destination" => DEST_DIR
    })
  end

  def fixture_site
    @site ||= Jekyll::Site.new(config)
  end

  def page_with_name(site, name)
    site.pages.find { |p| p.name == name }
  end

  def document(doc_filename)
    @site.collections["docs"].docs.find { |d| d.relative_path.match(doc_filename) }
  end
end
