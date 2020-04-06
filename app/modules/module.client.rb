module Sinatra

  module Podcast

    module Client

      # Abort if required environmental variables are not set
      if ENV["CONTENTFUL_DELIVERY_KEY"].nil? || ENV["CONTENTFUL_SPACE_ID"].nil?
        abort("Environmental variables CONTENTFUL_DELIVERY_KEY and CONTENTFUL_SPACE_ID not set.")
      end

      # Attempt to initialize Contentful Delivery API client
      begin

        # NOTE! It's possible to initialize client with invalid API key and/or space ID
        $client = Contentful::Client.new(
          :access_token => ENV["CONTENTFUL_DELIVERY_KEY"],
          :space        => ENV["CONTENTFUL_SPACE_ID"]
        )

      rescue
        halt 500, "Unable to initialize Contentful Delivery API client."
      end

    end

  end

end