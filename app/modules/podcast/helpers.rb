# frozen_string_literal: true

module Sinatra
  module Podcast
    module Helpers
      # Filter unwanted characters from URL slug
      def parse_slug(string)
        string.tr('^a-zA-Z0-9-_', '')
      end

      # Filter unwanted characters from ID
      def parse_id(string)
        string.tr('^0-9', '').to_i
      end

      # Parse genre name to URL friendly form
      def parse_genre(string)
        string.downcase.gsub(' ', '_').tr('^a-z-_', '').gsub('__', '_')
      end

      # Parse search parameters from URL
      def parse_search_params(params, genre)
        # Map brands, genres and order methods into available URL-parameter values
        brands = $brands.map(&:slug)
        genres = $genres.sort.map { |key, _value| key }
        genre = genre.nil? ? 'any' : genre
        order = $default_locals[:search][:fields][:order][:options].map { |_key, value| value }

        # Set URL-parameter values for search or use defaults
        {
          brand: brands.include?(params['brand']) ? params['brand'] : 'any',
          genre: genres.include?(params['genre']) ? params['genre'] : genre,
          limit: $search_items.include?(params['limit'].to_i) ? params['limit'] : '12',
          order: order.include?(params['order']) ? params['order'] : 'date-desc',
          id: 'none',
          page: !params['page'].to_i.zero? ? parse_slug(params['page']) : '1'
        }
      end

      # Convert Markdown to HTML
      def md(string)
        coder = Redcarpet::Markdown.new(
          Redcarpet::Render::HTML,
          autolink: false,
          tables: true,
          escape_html: false
        )

        coder.render(string).html_safe
      end

      # Strip Markdown to plain text and remove links
      def st(string)
        coder = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
        coder.render(string).html_safe.gsub(%r{(\(?:f|ht)tps?:/[^\s]+\)}, '').gsub(' (', '')
      end

      # Parse string to CDATA
      def cd(string)
        "<![CDATA[#{string}]]>".html_safe
      end
    end
  end
end
