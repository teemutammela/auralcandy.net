# frozen_string_literal: true

require 'contentful/management'
require 'dotenv/load'

# Modules
require_relative('app/modules/contentful/management')

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
