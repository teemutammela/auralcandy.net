# frozen_string_literal: true

module Sinatra
  module Podcast
    module Defaults
      def self.registered(app)
        # Set shared variables and other default values before handling routes
        app.before do
          # Attempt to query brands and catch errors for invalid API key or space ID
          begin
            defaults = $delivery.entries(
              :content_type => 'brand',
              :include => 1,
              'fields.default' => true
            )
          rescue StandardError
            halt 500, 'Unable to connect to Contentful Delivery API. Most likely invalid API key or space ID.'
          end

          # Set default brand (first matching)
          if defaults.size.positive?
            $brand = Brand.new(defaults.first)
          else
            halt 500, 'No default brand set.'
          end

          # Set cache (production mode)
          expires 60 * 60 * 24, :public, :must_revalidate unless settings.development?

          # Set base URL (force HTTPS in production mode)
          $base_url = request.base_url
          $base_url = $base_url.sub('http://', 'https://') unless settings.development?

          # RSS subscription URL (opens default client)
          $subscribe_url = "pcast://#{request.host_with_port}/podcast"

          # Allowed numbers of items for episode search
          $search_items = [12, 24, 36, 48]

          # Get brands, genres and episode slugs
          $brands = brands
          $genres = genres
          $slugs  = slugs

          # Build navigation menu
          $navigation_links = []

          $brand.navigation_menu.each do |navigation_item|
            navigation_link = {
              name: navigation_item.name,
              description: navigation_item.description
            }

            case navigation_item.class.to_s
            when 'NavigationLink'
              navigation_link[:url] = navigation_item.link_url
            when 'NavigationAnchor'
              navigation_link[:url] = navigation_item.link_anchor
            end

            $navigation_links.push(navigation_link)
          end

          # Default variables shared by views
          $default_locals = {
            links: $navigation_links,
            search: {
              fields: {
                brand: {
                  name: 'Brand',
                  options: $brands.map { |brand| [brand.name, brand.slug] }.insert(0, ['Any Brand', 'any'])
                },
                genre: {
                  name: 'Genre',
                  options: $genres.sort.map { |key, value| [value, key] }.insert(0, ['Any Genre', 'any'])
                },
                limit: {
                  name: 'Episodes',
                  options: $search_items.map { |items| ["#{items} Per Page", items.to_s] }
                },
                order: {
                  name: 'Order',
                  options: [
                    ['Latest &rarr; Eldest'.html_safe, 'date-desc'],
                    ['Eldest &rarr; Latest'.html_safe, 'date-asc'],
                    ['Most Popular &rarr; Least Popular'.html_safe, 'popularity-desc'],
                    ['Least Popular &rarr; Most Popular'.html_safe, 'popularity-asc'],
                    ['Title A &rarr; Z'.html_safe, 'title-asc'],
                    ['Title Z &rarr; A'.html_safe, 'title-desc']
                  ]
                }
              }
            },
            footer: {
              brand_name: $brand.name,
              description: md($brand.long_description),
              privacy_policy: md($brand.privacy_policy),
              street_address: $brand.street_address,
              zip_code: $brand.zip_code,
              locality: $brand.locality,
              email: $brand.email,
              phone: $brand.phone
            }
          }
        end
      end
    end
  end
end
