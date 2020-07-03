module Sinatra

  module Podcast

    module Helpers

      # Filter unwanted characters from URL slug
      def parse_slug(string)
        string.tr("^a-zA-Z0-9-_", "")
      end

      # Filter unwanted characters from ID
      def parse_id(string)
        string.tr("^0-9", "").to_i
      end

      # Parse genre name to URL friendly form
      def parse_genre(string)
        string.downcase.gsub(" ", "_").tr("^a-z-_", "").gsub("__", "_")
      end

      # Convert Markdown to HTML
      def md(string)

        coder = Redcarpet::Markdown.new(
        	Redcarpet::Render::HTML,
        	:autolink     => false,
        	:tables       => true,
        	:escape_html  => false
        )

        coder.render(string).html_safe

      end

      # Strip Markdown to plain text and remove links
      def st(string)
        coder = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
        coder.render(string).html_safe.gsub(/(\(?:f|ht)tps?:\/[^\s]+\)/, "").gsub(" (", "")
      end

      # Parse string to CDATA
      def cd(string)
        "<![CDATA[#{string}]]>".html_safe
      end

			# Scramble artist and track name if marker is found
			def scramble_track_name(track)

				# NOTE! This method was added as an countermeasure after we received a RIAA copyright claim.
				# While we do not advocate for privacy, especially for profit, these copyright claims are utter BS.
				# Granted, DJ mixes have always been bit of a gray area when it comes to copyright.
				# Having said that, most artist and record labels view them as a positive thing and leave them be.
				# In our opinion, going after non-profit podcasts is an overkill and counterproductive.
				# We don't earn a single penny. Quite the contrary, we spend thousands doing free promotion for the music we love.

				marker = "[SCRAMBLE]"

				if track.include?(marker)
					track		= track.gsub(marker, "").strip
					artist	= scramble_string(track.split(" - ")[0])
					track		= scramble_string(track.split(" - ")[1])
					track		= [artist, track].join(" - ")
				end

				return track

			end

			# Scramble string by inserting random invisible characters
			def scramble_string(str)

				str = str.split("")

				(0..(str.size/2).to_i).each do |i|
					str.insert(rand(1..str.size), "<span style=\"display: none;\">#{[*"a".."z"].sample}</span>")
				end

				return str.join("")

			end

    end

  end

end