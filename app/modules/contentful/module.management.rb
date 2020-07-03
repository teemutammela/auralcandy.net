module Contentful

  module Management

    # Abort if required environmental variables are not set
    if ENV["CONTENTFUL_MANAGEMENT_KEY"].nil? || ENV["CONTENTFUL_SPACE_ID"].nil? || ENV["CONTENTFUL_ENVIRONMENT"].nil?
      abort("Environmental variables CONTENTFUL_MANAGEMENT_KEY, CONTENTFUL_SPACE_ID or CONTENTFUL_ENVIRONMENT not set.")
    end

    # Attempt to initialize Contentful Management API client
    begin

      $management = Contentful::Management::Client.new(
        ENV["CONTENTFUL_MANAGEMENT_KEY"]
      ).environments(
        ENV["CONTENTFUL_SPACE_ID"]
      ).find(
        ENV["CONTENTFUL_ENVIRONMENT"]
      )

    rescue
      abort("Unable to initialize Contentful Management API client.")
    end

  end

end