# Gems
require "sinatra/base"
require "sinatra/multi_route"
require "sinatra/partial"
require "padrino-helpers"
require "tilt/erb"
require "rack/cache"
require "rack/protection"
require "contentful"
require "date"
require "active_support/core_ext/integer/inflections"
require "redcarpet"
require "redcarpet/render_strip"
require "json"

# Modules
require_relative("modules/module.client.rb")
require_relative("modules/module.defaults.rb")
require_relative("modules/module.helpers.rb")
require_relative("modules/module.queries.rb")
require_relative("modules/module.routing.rb")

# Legacy handlers (safe to remove)
require_relative("modules/module.legacy.rb")

# Object wrapper classes
require_relative("classes/class.brand.rb")
require_relative("classes/class.dj.rb")
require_relative("classes/class.episode.rb")
require_relative("classes/class.label.rb")

# Main application
class Podcast < Sinatra::Base

  register Sinatra::MultiRoute
  register Sinatra::Podcast::Client
  register Sinatra::Podcast::Defaults
  register Sinatra::Podcast::Routing
  register Sinatra::Podcast::Legacy   # Safe to remove (remove 'require_relative("modules/module.legacy.rb")' first)
  register Sinatra::Partial
  register Padrino::Helpers

  helpers Sinatra::Podcast::Queries
  helpers Sinatra::Podcast::Helpers

  # Global configuration (all environments)
  configure do

    # Global limit for fetching entries
    set :limit, 500

    # Partials template engine
    set :partial_template_engine, :erb

    # Match static files before routes
    enable :static

  end

  # Development environment configuration
  configure :development do

    use Rack::Session::Pool, :expire_after => 0

    set :environment, :development
    set :static_cache_control, [:public, max_age: 0]

    enable :reload_templates, :logging, :dump_errors, :show_exceptions, :asset_stamp
    disable :protection

  end

  # Production environment configuration
  configure :production do

    use Rack::Session::Pool, :expire_after => 60 * 60 * 24 * 30
    use Rack::Cache
    use Rack::Deflater
    use Rack::Protection

    set :environment, :production
    set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 30]

    enable :protection, :quiet
    disable :reload_templates, :logging, :dump_errors, :show_exceptions, :asset_stamp

  end

end