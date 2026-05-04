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
        brand_slugs = @brands.map(&:slug)
        genre_slugs = @genres.sort.map { |key, _value| key }
        genre = genre.nil? ? 'any' : genre
        order = @site_locals[:search][:fields][:order][:options].map { |_key, value| value }

        # Set URL-parameter values for search or use defaults
        {
          brand: brand_slugs.include?(params['brand']) ? params['brand'] : 'any',
          genre: genre_slugs.include?(params['genre']) ? params['genre'] : genre,
          limit: search_items.include?(params['limit'].to_i) ? params['limit'] : search_items.first.to_s,
          order: order.include?(params['order']) ? params['order'] : 'date-desc',
          id: 'none',
          page: !params['page'].to_i.zero? ? parse_slug(params['page']) : '1'
        }
      end

      # Current default brand for the request
      def current_brand
        @brand
      end

      # Site locals shared by views
      def site_locals
        @site_locals
      end

      # Base URL for generated absolute links
      def base_url
        url = request.base_url
        settings.development? ? url : url.sub('http://', 'https://')
      end

      # RSS subscription URL (opens default client)
      def subscribe_url
        "podcast://#{request.host_with_port}/podcast"
      end

      # Allowed numbers of items for episode search
      def search_items
        Sinatra::Podcast::Defaults::SEARCH_ITEMS
      end

      # Episode URL for a given slug
      def episode_url(slug)
        slug ? "#{base_url}/episodes/#{slug}" : false
      end

      # Previous episode URL
      def previous_episode_url(episode)
        index = episode_index(episode)
        return false if index.nil? || index.zero?

        episode_url(episode_slugs[index - 1])
      end

      # Next episode URL
      def next_episode_url(episode)
        index = episode_index(episode)
        return false if index.nil? || index >= episode_slugs.size - 1

        episode_url(episode_slugs[index + 1])
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

      private

      def episode_slugs
        @slugs || []
      end

      def episode_index(episode)
        episode_slugs.index(episode.slug)
      end
    end
  end
end
