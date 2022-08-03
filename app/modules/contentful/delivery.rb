# frozen_string_literal: true

module Contentful
  module Delivery
    # Abort if required environmental variables are not set
    %w[CONTENTFUL_DELIVERY_KEY CONTENTFUL_SPACE_ID].each do |env|
      abort("Environmental variable #{env} not set.") if ENV[env].to_s.empty?
    end

    # Attempt to initialize Contentful Delivery API client
    begin
      # NOTE! It's possible to initialize client with invalid API key and/or space ID
      $delivery = Contentful::Client.new(
        access_token: ENV['CONTENTFUL_DELIVERY_KEY'],
        space: ENV['CONTENTFUL_SPACE_ID'],
        environment: ENV['CONTENTFUL_ENVIRONMENT']
      )
    rescue StandardError
      halt 500, 'Unable to initialize Contentful Delivery API client.'
    end
  end
end
