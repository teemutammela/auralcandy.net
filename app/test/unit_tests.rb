# frozen_string_literal: true

require 'test/unit'
require 'rack/test'
require 'optparse'
require 'yaml'

# Command line options
OptionParser.new do |option|
  # Contentful Delivery API key
  option.on('-k', '--key KEY') do |key|
    ENV['CONTENTFUL_DELIVERY_KEY'] = key.strip
  end

  # Contentful space ID
  option.on('-s', '--space SPACE') do |space|
    ENV['CONTENTFUL_SPACE_ID'] = space.strip
  end

  # Sinatra environment
  option.on('-e', '--environment ENVIRONMENT') do |environment|
    ENV['RACK_ENV'] = environment.strip
  end
end.parse!

# Include main application
require_relative('../app')

# Test Suite
class PodcastTest < Test::Unit::TestCase
  include Rack::Test::Methods

  # Load assertions from YAML file
  $assertions = YAML.load_file('app/test/assertions.yml')

  # Reference main application
  def app
    Podcast
  end

  # Web Application Manifest
  def test_web_app_manifest
    get '/manifest.json'

    assert last_response.ok?
    $assertions['manifest'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end

  # Podcast RSS/XML feed
  def test_podcast_xml
    # Get route
    get '/podcast'

    assert last_response.ok?
    $assertions['podcast'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end

  # Sitemal XML
  def test_sitemap_xml
    get '/sitemap.xml'

    assert last_response.ok?
    $assertions['sitemap'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end

  # Index view
  def test_index_view
    get '/'

    assert last_response.ok?
    $assertions['index'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end

  # Search - Default
  def test_search_default
    get '/search/any/any/12/date-asc/none/1'

    assert last_response.ok?
    $assertions['search_default'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end

  # Search - Brand
  def test_search_brand
    get '/search/secondary-brand/any/12/date-asc/none/1'

    assert last_response.ok?
    $assertions['search_brand'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end

  # Search - Genre
  def test_search_genre
    get '/search/any/deep-house/12/date-asc/none/1'

    assert last_response.ok?
    $assertions['search_genre'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end

  # Search - Popularity
  def test_search_popularity
    get '/search/any/any/12/popularity-desc/none/1'

    assert last_response.ok?
    $assertions['search_popularity'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end

  # Episode view
  def test_episode_view
    get '/episodes/example-episode-1'

    assert last_response.ok?
    $assertions['episode'].each do |assertion|
      assert last_response.body.include?(assertion.to_s)
    end
  end
end
