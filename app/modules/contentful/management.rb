# frozen_string_literal: true

module Contentful
  module Management
    def management
      @management ||= begin
        # Abort if required environmental variables are not set
        %w[CONTENTFUL_MANAGEMENT_KEY CONTENTFUL_SPACE_ID CONTENTFUL_ENVIRONMENT].each do |env|
          abort("Environmental variable #{env} not set.") if ENV[env].to_s.empty?
        end

        # Attempt to initialize Contentful Management API client
        Contentful::Management::Client.new(
          ENV['CONTENTFUL_MANAGEMENT_KEY']
        ).environments(
          ENV['CONTENTFUL_SPACE_ID']
        ).find(
          ENV['CONTENTFUL_ENVIRONMENT']
        )
      rescue StandardError
        abort('Unable to initialize Contentful Management API client.')
      end
    end
  end
end
