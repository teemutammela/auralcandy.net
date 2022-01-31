# frozen_string_literal: true

module Chartable
  # Send GET request to Chartable API (returns 10 episodes per page)
  def get_chartable_api_page(page)
    response = Faraday.new.get do |request|
      # Build Chartable API URL
      chartable_api_url = 'https://chartable.com/api/episodes'
      chartable_api_url += "?podcast_id=#{ENV['CHARTABLE_PODCAST_ID']}"
      chartable_api_url += "&team_id=#{ENV['CHARTABLE_PODCAST_ID']}"
      chartable_api_url += "&page=#{page}"

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
  def get_chartable_data
    begin
      total = $management.entries.all(content_type: 'episode').total.to_i
      downloads = {}
      pages     = (total / 10) + 1
    rescue StandardError
      abort('Unable to connect to Contentful Management API. Check credentials.')
    end

    # Fetch data in multiple passes
    (1..pages).each do |page|
      data = get_chartable_api_page(page)

      # Populate hash with episode titles and downloads counts
      data.each do |episode|
        downloads[episode['title'].split(' - ')[1]] = episode['total_downloads'].to_i
      end
    end

    downloads
  end

  # Update Contentful entries via Management API
  def update_episode_downloads
    # Get episode downloads from Chartable API
    chartable_data = get_chartable_data

    # Query options
    options = {
      content_type: 'episode',
      limit: 999,
      order: '-fields.releaseDate'
    }

    # Query and update episode entries
    $management.entries.all(options).each do |episode|
      # Update download count to episode entry if found in Chartable data
      if episode.published? && chartable_data.key?(episode.fields[:title])
        episode.update(downloads: chartable_data[episode.fields[:title]])
        episode.publish

      # Set download count to zero if not found in Chartable
      elsif episode.published? && !chartable_data.key?(episode.fields[:title])
        episode.update(downloads: 0)
        episode.publish
      end
    end
  end
end
