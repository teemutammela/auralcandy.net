# frozen_string_literal: true

require 'contentful/management'
require 'dotenv/load'
require 'faraday'
require 'json'

# Modules
require_relative('app/modules/contentful/management')
require_relative('app/modules/chartable/chartable')

# Chartable tasks
namespace :chartable do
  include Contentful::Management
  include Chartable

  desc 'Chartable - Import Podcast Downloads'
  task :import do
    # Verify that required environmental variables are set
    %w[CHARTABLE_PODCAST_ID CHARTABLE_ACCESS_TOKEN].each do |env|
      abort("Environmental variable #{env} not set.") if ENV[env].to_s.empty?
    end

    update_episode_downloads
  end
end

namespace :podcast do
  desc 'Podcast - Run All Tests'
  task :test do
    # Verify that required environmental variables are set
    %w[CONTENTFUL_DELIVERY_KEY_TEST CONTENTFUL_SPACE_ID_TEST].each do |env|
      abort("Environmental variable #{env} not set.") if ENV[env].to_s.empty?
    end

    contentful_delivery_key = ENV['CONTENTFUL_DELIVERY_KEY_TEST']
    contentful_space_id     = ENV['CONTENTFUL_SPACE_ID_TEST']
    rack_environment        = ENV['RACK_ENV'].to_s.empty? ? 'development' : ENV['RACK_ENV']

    # Execute unit tests
    sh "ruby app/test/tests.rb -k #{contentful_delivery_key} -s #{contentful_space_id} -e #{rack_environment}"
  end
end
