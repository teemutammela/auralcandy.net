# frozen_string_literal: true

module Sinatra
  module Podcast
    module Routes
      def self.registered(app)
        # Index
        app.get '/' do
          # Parse search parameters
          search_params = parse_search_params(params, nil)

          # Query default episode set
          results = search_episodes(
            search_params[:brand],
            search_params[:genre],
            search_params[:limit],
            search_params[:order],
            search_params[:id],
            search_params[:page]
          )

          # Pass variables to template
          erb :index, locals: {
            search_params:,
            list_result: {
              episodes: results[:episodes],
              current: search_params[:page].to_i,
              pages: results[:pages].to_i,
              page_url: results[:page_url],
              genre: search_params[:genre]
            }
          }
        end

        # Episode landing page
        app.get '/episodes/:slug/?' do |slug|
          # Query episode and sample genre for related content
          episode = episode_by_slug(slug)
          genre = parse_genre(episode.genre.sample)
          search_params = parse_search_params(params, genre)

          # Query default episode set
          results = search_episodes(
            search_params[:brand],
            search_params[:genre],
            search_params[:limit],
            search_params[:order],
            episode.id,
            search_params[:page]
          )

          # Set headers
          last_modified(episode.updated) unless settings.development?

          # Pass variables to template
          erb :episode, locals: {
            episode:,
            search_params:,
            list_result: {
              episodes: results[:episodes],
              current: search_params[:page].to_i,
              pages: results[:pages].to_i,
              page_url: results[:page_url],
              genre:
            }
          }
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

        # Web app manifest
        app.get '/manifest.json' do
          # Set headers
          unless settings.development?
            last_modified(Time.now - (60 * 60 * 24 * 7))
            cache_control :public, :must_revalidate, max_age: 60 * 60 * 24 * 30
          end

          erb :manifest, locals: { brand: $brand }, content_type: 'application/json'
        end

        # Options (used only to block certain types of bots)
        app.options '/*' do
          halt 405, 'Method Not Allowed'
        end

        # Page not found
        app.not_found do
          redirect '/'
        end
      end
    end
  end
end
