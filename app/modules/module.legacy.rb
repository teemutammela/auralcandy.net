module Sinatra

  module Podcast

    module Legacy
      
      module Helpers

        # Redirect legacy episode ID or file name to up-to-date URL
        def legacy_redirect(type, key)
  
          mapping  = JSON.parse(eat("app/legacy/#{type}.json"))
          entry_id = mapping[key]
          halt 404 if entry_id.nil?
          episode  = get_episode_by_id(entry_id)
  
          case type
          when "episode"
            url = episode.url
          when "audio"
            url = episode.audio_url
          else
            url = $base_url
          end
  
          redirect to(url), 301
  
        end

      end
      
      def self.registered(app)
        
        app.helpers Legacy::Helpers

        # Episode landing page redirection
        app.get "/episode/:id/?" do |id|
          legacy_redirect("episode", parse_id(id))
        end

        # Audio file redirection
        app.get "/audio/*.mp3" do |file|
          legacy_redirect("audio", file)
        end

      end

    end

  end

end