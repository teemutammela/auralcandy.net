require "test/unit"
require "rack/test"
require "optparse"

# Command line options
OptionParser.new do |option|

	# Contentful Delivery API key
  option.on("-k", "--key KEY") do |key|
    ENV["CONTENTFUL_DELIVERY_KEY"] = key.strip
  end

  # Contentful space ID
  option.on("-s", "--space SPACE") do |space|
    ENV["CONTENTFUL_SPACE_ID"] = space.strip
  end

  # Sinatra environment
  option.on("-e", "--environment ENVIRONMENT") do |environment|
    ENV["RACK_ENV"] = environment.strip
  end

end.parse!

# Include main application
require_relative("../app")

# Test Suite
class PodcastTest < Test::Unit::TestCase

  include Rack::Test::Methods

  # Reference main application
  def app
    Podcast
  end

  # Web Application Manifest
  def test_web_app_manifest

    get "/manifest.json"

    assert last_response.ok?
    assert last_response.body.include?("\"name\": \"Primary Brand - Primary Brand Tagline\"")
    assert last_response.body.include?("\"description\": \"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sed ullamcorper sapien mauris at urna a purus.\"")

  end

  # Podcast RSS/XML feed
  def test_podcast_xml

    # Get route
    get "/podcast"

    assert last_response.ok?

    # Brand
    assert last_response.body.include?("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>")
    assert last_response.body.include?("<title><![CDATA[Primary Brand - Primary Brand Tagline]]></title>")
    assert last_response.body.include?("<description><![CDATA[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sed ullamcorper sapien mauris at urna a purus.]]></description>")
    assert last_response.body.include?("<itunes:email><![CDATA[contact@email.com]]></itunes:email>")

    # Episode
    assert last_response.body.include?("<title><![CDATA[DJ First - Example Episode 1]]></title>")
    assert last_response.body.include?("/episodes/example-episode-1</link>")
    assert last_response.body.include?("<li>Producer feat. Vocalist - Track Name [Mix Name]</li>")
    assert last_response.body.include?("the_funk_formula.png")
    assert last_response.body.include?("sample_audio.mp3")
    assert last_response.body.include?("<pubDate>Thu, 11 Apr 2019 00:00:00 +0000</pubDate>")
    assert last_response.body.include?("<itunes:duration>00:00:27</itunes:duration>")
    assert last_response.body.include?("<itunes:keywords><![CDATA[DJ, Podcast, Deep House, House Music, Progressive House]]></itunes:keywords>")

  end

  # Sitemal XML
  def test_sitemap_xml

    get "/sitemap.xml"

    assert last_response.ok?
    assert last_response.body.include?("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>")
    assert last_response.body.include?("/episodes/example-episode-1")
    assert last_response.body.include?("/episodes/example-episode-2")
    assert last_response.body.include?("/episodes/example-episode-3")

  end

  # Index view
  def test_index_view

    get "/"

    assert last_response.ok?

		# Head
    assert last_response.body.include?("<meta name=\"description\" content=\"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sed ullamcorper sapien mauris at urna a purus.\" />")
    assert last_response.body.include?("<meta name=\"keywords\" content=\"dj, podcast, music\" />")
    assert last_response.body.include?("<title>Primary Brand - Primary Brand Tagline</title>")

    # Body - Main navigation links
    assert last_response.body.include?("<a href=\"/\" class=\"navbar-brand\" title=\"Home\">Primary Brand</a>")
    assert last_response.body.include?("<a href=\"https://podcasts.apple.com/podcast/auralcandy-net/id291192514\" class=\"nav-link\" title=\"Apple Podcasts\" itemprop=\"relatedLink\">Apple Podcasts</a>")
    assert last_response.body.include?("<a href=\"https://podcasts.google.com/?feed=aHR0cDovL3d3dy5hdXJhbGNhbmR5Lm5ldC94bWwvcnNzLnhtbA\" class=\"nav-link\" title=\"Google Podcasts\" itemprop=\"relatedLink\">Google Podcasts</a>")

    # Body - Search form elements
    assert last_response.body.include?("<form id=\"episode-search\">")
    assert last_response.body.include?("<option value=\"secondary-brand\">Secondary Brand</option>")
    assert last_response.body.include?("<option value=\"progressive_house\">Progressive House</option>")
    assert last_response.body.include?("<option value=\"24\">24 Per Page</option>")
    assert last_response.body.include?("<option value=\"date-desc\" selected=\"selected\">")

  end

  # Search - Default
  def test_search_default

    get "/search/any/any/12/date-asc/none/1"

    assert last_response.ok?
    assert last_response.body.include?("<h2 class=\"card-header text-center text-muted\" itemprop=\"name\">Example Episode 1</h2>")
    assert last_response.body.include?("<li title=\"Deep House\" class=\"badge badge-pill badge-primary\">Deep House</li>")
		assert last_response.body.include?("the_funk_formula.png")
    assert last_response.body.include?("sample_audio.mp3")
    assert last_response.body.include?("<time class=\"col text-left text-nowrap\" datetime=\"2019-04-11\" itemprop=\"datePublished\">")

  end

  # Search - Brand
  def test_search_brand

    get "/search/secondary-brand/any/12/date-asc/none/1"

    assert last_response.ok?
    assert last_response.body.include?("<h2 class=\"card-header text-center text-muted\" itemprop=\"name\">Example Episode 3</h2>")

  end

  # Search - Genre
  def test_search_genre

    get "/search/any/deep-house/12/date-asc/none/1"

    assert last_response.ok?
    assert last_response.body.include?("<h2 class=\"card-header text-center text-muted\" itemprop=\"name\">Example Episode 1</h2>")
    assert last_response.body.include?("<li title=\"Deep House\" class=\"badge badge-pill badge-primary\">Deep House</li>")

  end

  # Episode view
  def test_episode_view

    get "/episodes/example-episode-1"

    assert last_response.ok?

    # Head
    assert last_response.body.include?("<meta name=\"keywords\" content=\"DJ, Podcast, Deep House, House Music, Progressive House\" />")
    assert last_response.body.include?("/episodes/example-episode-2\" rel=\"prev\" />")
    assert last_response.body.include?("<title>Example Episode 1 by DJ First - Primary Brand</title>")

    # Body
    assert last_response.body.include?("<h1 class=\"jumbotron-heading\">Example Episode 1</h1>")
    assert last_response.body.include?("<li title=\"Deep House\" class=\"badge badge-pill badge-primary\">Deep House</li>")
		assert last_response.body.include?("data-dj=\"DJ First\"")
		assert last_response.body.include?("data-title=\"Example Episode 1\"")
		assert last_response.body.include?("<div class=\"text-muted\">Producer feat. Vocalist</div>")
		assert last_response.body.include?("<div class=\"small\">Track Name [Mix Name]</div>")
		assert last_response.body.include?("<time class=\"col text-left text-nowrap\" datetime=\"2019-04-11\" itemprop=\"datePublished\">")
		assert last_response.body.include?("<div class=\"col text-right text-nowrap\" itemprop=\"author\">DJ First</div>")

  end

  # Error - Invalid episode slug
  def test_invalid_episode_slug

	  get "/episodes/does-not-exist"

		assert_equal 404, last_response.status

		assert last_response.body.include?("<h1 class=\"jumbotron-heading\">404 Not Found</h1>")
		assert last_response.body.include?("<div class=\"lead\" itemprop=\"description\">The content you are looking for was not found.</div>")

	end

	# Error - Invalid route
	def test_invalid_route

		get "/does-not-exist"

		assert_equal 404, last_response.status

		assert last_response.body.include?("<h1 class=\"jumbotron-heading\">404 Not Found</h1>")
		assert last_response.body.include?("<div class=\"lead\" itemprop=\"description\">The content you are looking for was not found.</div>")

	end

end