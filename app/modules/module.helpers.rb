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
        coder = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: false, tables: true, escape_html: false)
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

    end

  end

end