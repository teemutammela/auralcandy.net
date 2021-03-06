require "contentful/management"
require "faraday"
require "json"
require "dotenv/load"

# Modules
require_relative("app/modules/contentful/module.management.rb")
require_relative("app/modules/chartable/module.chartable.rb")

# Chartable tasks
namespace :chartable do

  include Contentful::Management
  include Chartable

  desc "Chartable - Import Podcast Downloads"
  task :import do

    # Verify that required environmental variables are set
    ["CHARTABLE_PODCAST_ID", "CHARTABLE_ACCESS_TOKEN"].each do |env|
      abort("Environmental variable #{env} not set.") if ENV[env].to_s.empty?
    end

    update_episode_downloads

  end

end

namespace :test do

  desc "Test - Run All Unit Tests"
  task :run do

    # Verify that required environmental variables are set
    ["CONTENTFUL_DELIVERY_KEY_TEST", "CONTENTFUL_SPACE_ID_TEST"].each do |env|
      abort("Environmental variable #{env} not set.") if ENV[env].to_s.empty?
    end

    contentful_delivery_key = ENV["CONTENTFUL_DELIVERY_KEY_TEST"]
    contentful_space_id     = ENV["CONTENTFUL_SPACE_ID_TEST"]
    rack_environment        = ENV["RACK_ENV"].to_s.empty? ? 'development' : ENV["RACK_ENV"]

    # Execute unit tests
    sh "ruby app/test/unit_tests.rb -k #{contentful_delivery_key} -s #{contentful_space_id} -e #{rack_environment}"

  end

end