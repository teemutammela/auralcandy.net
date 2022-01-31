# frozen_string_literal: true

module Sinatra
  module Podcast
    module Queries
      # Query entries and wrap them as requested objects
      def objects(wrapper, options)
        $delivery.entries(options).to_a.map { |item| wrapper.constantize.new(item) }
      end

      # Get all brands and wrap them as 'Brand' objects
      def brands
        options = {
          content_type: 'brand',
          include: 1,
          order: 'sys.createdAt'
        }

        objects('Brand', options)
      end

      # Build a hash list of all genres (e.g. :genre_name => "Genre Name")
      def genres
        genres = {}

        # Extract genres from the 'Episode' content type's validation rules
        $delivery.content_type('episode').fields.select do |field|
          field.id == 'genre'
        end.first.items.raw['validations'].first['in'].each do |genre|
          genres[parse_genre(genre)] = genre
        end

        genres
      end

      # Get episodes using requested options and wrap them as 'Episode' objects
      def episodes(options)
        # Set default options unless defined in the options hash
        options[:content_type]  = 'episode'
        options[:include]       = 2 unless options.key?(:include)
        options[:order]         = '-fields.releaseDate' unless options.key?(:order)

        objects('Episode', options)
      end

      # Get episode by URL slug
      def episode_by_slug(slug)
        # Query options
        options = {
          :content_type => 'episode',
          :include => 2,
          'fields.slug' => parse_slug(slug)
        }

        # Query single episode with first matching slug
        episode = $delivery.entries(options).first

        # Parse to object or halt if not found
        halt 404 if episode.nil?
        Episode.new(episode)
      end

      # Get a list of all episode slugs
      def slugs
        # Query options
        options = {
          content_type: 'episode',
          include: 0,
          order: 'fields.releaseDate',
          select: 'fields.slug',
          limit: 999
        }

        # Query slugs and map to array
        $delivery.entries(options).map { |episode| episode.fields[:slug] }
      end

      # Get a single episode by ID and wrap as 'Episode' object, halt if not found
      def episode_by_id(id)
        episode = $delivery.entry(id, include: 2)
        halt 404 if episode.nil?
        Episode.new(episode)
      end

      # Search episodes via filters
      def search_episodes(brand, genre, limit, order, id, page)
        # Parse option variables
        brand = parse_slug(brand)
        order = parse_slug(order)
        limit = parse_id(limit)
        genre = parse_slug(genre)
        id    = parse_slug(id)
        page  = parse_id(page) - 1

        # Allowed sorting methods
        sort = {
          'date-desc' => '-fields.releaseDate',
          'date-asc' => 'fields.releaseDate',
          'popularity-desc' => '-fields.downloads',
          'popularity-asc' => 'fields.downloads',
          'title-desc' => '-fields.title',
          'title-asc' => 'fields.title'
        }

        # Query options (limit, ordering method)
        options = {
          limit: $search_items.include?(limit) ? limit : $search_items.first,
          order: sort.key?(order) ? sort[order] : '-fields.releaseDate'
        }

        # Merge brand filter to search options
        if $brands.map(&:slug).include?(brand)
          options.merge!('fields.brand.sys.contentType.sys.id'.to_sym => 'brand')
          options.merge!('fields.brand.fields.slug'.to_sym => brand)
        end

        # Merge genre filter to search options
        # NOTE! [match] filter is used to enable search with genre names converted to URL-friendly form
        # NOTE! [match] filter returns all partial matches, i.e. search phrase "Funk" matches both "Funk" and "Funky House"
        options.merge!('fields.genre[match]'.to_sym => genre) if $genres.key?(genre)

        # Merge leave-out ID to query options
        options.merge!('sys.id[ne]'.to_sym => id) unless id == 'none'

        # Merge paging number to query options
        options.merge!(skip: page * options[:limit])

        # Query episodes, get total sum of episodes, pass parameters back for pagination link
        {
          episodes: episodes(options),
          pages: ($delivery.entries(options.merge!(content_type: 'episode')).total / options[:limit].to_f).ceil,
          page_url: create_page_url(brand, genre, limit, order, id)
        }
      end

      # Create pagination URL string for search function
      def create_page_url(brand, genre, limit, order, id)
        "/search/#{brand}/#{genre}/#{limit}/#{order}/#{id}/"
      end
    end
  end
end
