module Sinatra

  module Podcast

    module Client

      # Attempt to initialize Contentful Delivery API client
      begin

        # NOTE! It's possible to initialize client with invalid API key and/or space ID
        $client = Contentful::Client.new(:access_token => ENV["CONTENTFUL_DELIVERY_KEY"], :space => ENV["CONTENTFUL_SPACE_ID"])

      # Halt if environmental variables not found
      rescue
        halt 500, "Unable to initialize Contentful Delivery API client. Environmental variables CONTENTFUL_DELIVERY_KEY and CONTENTFUL_SPACE_ID not set."
      end

    end

  end

end