# frozen_string_literal: true

module Sinatra
  module Podcast
    module Routes
      def self.registered(app)
        # Index
        app.get '/' do
          erb :index
        end

        # Web app manifest
        app.get '/manifest.json' do
          # Set headers
          unless settings.development?
            last_modified(Time.now - (60 * 60 * 24 * 7))
            cache_control :public, :must_revalidate, max_age: 60 * 60 * 24 * 30
          end

          erb :manifest, locals: { brand: $brand }, content_type: 'application/json'
        end

        # Episode search listing
        app.get '/search/:brand/:genre/:limit/:order/:id/:page/?' do |brand, genre, limit, order, id, page|
          # Query episodes by search parameters
          results = search_episodes(brand, genre, limit, order, id, page)

          # Pass variables to template
          erb :list, locals: {
            episodes: results[:episodes],
            current: parse_id(page),
            pages: results[:pages].to_i,
            page_url: results[:page_url],
            genre: parse_slug(genre)
          }
        end

        # Episode landing page
        app.get '/episodes/:slug/?' do |slug|
          # Query episode
          episode = episode_by_slug(slug)

          # Set headers
          last_modified(episode.updated) unless settings.development?

          # Pass variables to template
          erb :episode, locals: { episode: }
        end

        # Podcast RSS feed
        app.get '/podcast/?', '/xml/rss.xml' do
          # Query episodes
          episodes = episodes(limit: settings.limit)

          # Set headers
          last_modified(episodes.first.updated) unless settings.development?
          headers['Accept-Ranges'] = 'bytes'

          # Pass variables to template
          erb :podcast, locals: { episodes: }, content_type: 'application/xml'
        end

        # XML sitemap for Google
        app.get '/sitemap.xml', '/xml/sitemap.xml' do
          # Query episodes
          episodes = episodes(limit: settings.limit)

          # Set headers
          last_modified(episodes.first.updated) unless settings.development?
          headers['Accept-Ranges'] = 'bytes'

          # Pass variables to template
          erb :sitemap, locals: { episodes: }, content_type: 'application/xml'
        end

        # Options (used only to block certain types of bots)
        app.options '/*' do
          halt 405, 'Method Not Allowed'
        end

        # Page not found
        app.not_found do
          erb :not_found, locals: {
            title: '404 Not Found',
            message: 'The content you are looking for was not found.'
          }
        end
      end
    end
  end
end
