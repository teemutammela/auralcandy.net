# frozen_string_literal: true

require 'active_support/core_ext/integer/inflections'
require 'contentful'
require 'date'
require 'dotenv/load'
require 'json'
require 'padrino-helpers'
require 'rack/attack'
require 'rack/cache'
require 'redcarpet'
require 'redcarpet/render_strip'
require 'sinatra/base'
require 'sinatra/multi_route'

# Modules
require_relative('modules/contentful/delivery')
require_relative('modules/podcast/defaults')
require_relative('modules/podcast/helpers')
require_relative('modules/podcast/queries')
require_relative('modules/podcast/routes')

# Object wrapper classes
require_relative('classes/brand')
require_relative('classes/dj')
require_relative('classes/episode')
require_relative('classes/label')
require_relative('classes/navigation_anchor')
require_relative('classes/navigation_link')

# Main application
class Podcast < Sinatra::Base
  register Contentful::Delivery
  register Sinatra::MultiRoute
  register Sinatra::Podcast::Defaults
  register Sinatra::Podcast::Routes
  register Padrino::Helpers

  helpers Sinatra::Podcast::Queries
  helpers Sinatra::Podcast::Helpers

  # Global configuration (all environments)
  configure do
    # RSS & Sitemap XML entry limit
    set :limit, 100

    # Partials template engine
    set :partial_template_engine, :erb

    # Match static files before routes
    enable :static
  end

  # Development environment configuration
  configure :development do
    use Rack::Session::Pool, expire_after: 0, same_site: :strict

    set :environment, :development, :static
    set :static_cache_control, [:public, { max_age: 0 }]

    enable :reload_templates, :dump_errors, :show_exceptions, :asset_stamp
  end

  # Production environment configuration
  configure :production do
    Rack::Attack.blocklist('Block WordPress scan attempts') do |request|
      request.path.include?('wp-') || request.path.end_with?('.php')
    end

    Rack::Attack.blocklisted_responder = lambda do |_request|
      [410, { 'Content-Type' => 'text/plain' }, ['Piss off, script kiddie! This is not WordPress.']]
    end

    use Rack::Attack
    use Rack::Cache
    use Rack::Deflater
    use Rack::Session::Pool, expire_after: 60 * 60 * 24 * 30, same_site: :strict

    set :environment, :production, :static
    set :static_cache_control, [:public, { max_age: 60 * 60 * 24 * 365 }]

    enable :quiet
    disable :reload_templates, :dump_errors, :show_exceptions, :asset_stamp
  end
end
