# frozen_string_literal: true

module Chartable
  # Send GET request to Chartable API (returns 10 episodes per page)
  def chartable_api_page(page)
    response = Faraday.new.get do |request|
      # Build Chartable API URL
      chartable_api_url = 'https://chartable.com/api/episodes'
      chartable_api_url += "?podcast_id=#{ENV['CHARTABLE_PODCAST_ID']}"
      chartable_api_url += "&team_id=#{ENV['CHARTABLE_PODCAST_ID']}"
      chartable_api_url += "&page=#{page}"
      chartable_api_url += '&page_size=30'

      # Set request target URL
      request.url(chartable_api_url)

      # Set access token as Cookie header
      request.headers = { 'Cookie' => "remember_token=#{ENV['CHARTABLE_ACCESS_TOKEN']};" }

      # Set request timeout
      request.options.timeout = 10
    end

    # Parse JSON response to hash
    JSON.parse(response.body)
  rescue StandardError => e
    abort(e.message)
  end

  # Fetch downloads from Chartable API
  def chartable_data
    downloads = {}
    page = 1

    # Query result pages until API returns an empty array
    loop do
      data = chartable_api_page(page)
      page += 1
      break if data.empty?

      # Populate hash with episode titles and downloads counts
      data.each do |episode|
        # Extract episode title
        title = episode['title'].split(' - ')[1]

        # Combine download count from every episode of the same title
        # NOTE! Changed guid-parameters cause old episodes to be listed as new
        downloads[title] = if downloads.include?(title)
                             downloads[title].to_i + episode['total_downloads'].to_i
                           else
                             episode['total_downloads'].to_i
                           end
      end
    end

    downloads
  end

  # Update Contentful entries via Management API
  def update_episode_downloads
    # Get episode downloads from Chartable API
    data = chartable_data

    # Query options
    options = {
      content_type: 'episode',
      limit: 999,
      order: '-fields.releaseDate'
    }

    # Query and update episode entries
    $management.entries.all(options).each do |episode|
      title = episode.fields[:title]
      downloads = data[title]

      # Update download count to episode entry if found in Chartable data
      next unless episode.published? && data.key?(title)

      episode.update(downloads:)
      episode.publish
    end
  end
end
