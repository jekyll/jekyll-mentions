require 'rubygems'
require 'minitest/autorun'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jekyll-mentions'

TEST_DIR     = File.expand_path("../", __FILE__)
FIXTURES_DIR = File.expand_path("fixtures", TEST_DIR)
DEST_DIR     = File.expand_path("destination", TEST_DIR)

module MentionsTestHelpers
  def fixture_site
    Jekyll::Site.new(
      Jekyll::Utils.deep_merge_hashes(
        Jekyll::Configuration::DEFAULTS,
        {
          "source" => FIXTURES_DIR,
          "destination" => DEST_DIR
        }
      )
    )
  end

  def page_with_name(site, name)
    site.pages.find { |p| p.name == name }
  end
end
