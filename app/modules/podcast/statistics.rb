# frozen_string_literal: true

module Statistics
  # Query and update Contentful episode entries
  def update_episode_downloads(start_date)
    %w[OP3_SHOW_UUI OP3_API_TOKEN].each do |env|
      abort("Environmental variable #{env} not set.") if ENV[env].to_s.empty?
    end

    options = {
      content_type: 'episode',
      limit: 1000,
      order: '-fields.releaseDate'
    }

    $management.entries.all(options).each do |episode|
      downloads = episode_urls_and_downloads(start_date).find do |hash|
        hash[:url] == episode.fields[:fileUrl]
      end&.dig(:downloads)

      next unless episode.published?

      episode.update(downloads:)
      episode.publish
    end
  end

  private

  # Merge OP3 downloads with legacy Chartable downloads
  def episode_urls_and_downloads(start_date)
    @episode_urls_and_downloads ||= group_by_and_sum((op3_downloads(start_date) + chartable_downloads))
  end

  # Query OP3 downloads from REST API beginning from YYYY-MM-DD
  def op3_downloads(start_date)
    op3_downloads = []

    generate_date_ranges(start_date).each do |date_range|
      op3_downloads.concat(fetch_op3_downloads_for_range(date_range))
    end

    group_by_and_sum(op3_downloads)
  end

  # Fetch OP3 downloads for a specific date range
  def fetch_op3_downloads_for_range(date_range)
    response = Faraday.new.get do |request|
      url = "https://op3.dev/api/1/downloads/show/#{ENV['OP3_SHOW_UUID']}?format=json"
      url += '&limit=1000'
      url += "&start=#{date_range[:start_date]}"
      url += "&end=#{date_range[:end_date]}"

      request.url(url)
      request.headers = { 'Authorization' => "Bearer #{ENV['OP3_API_TOKEN']}" }
      request.options.timeout = 30
    end

    JSON.parse(response.body)['rows'].map do |download|
      url = download['url'].gsub('https://op3.dev/e/', '')
      { url: url, downloads: 1 }
    end
  end

  # Generate start and end date range for each month beginning from YYYY-MM-DD
  def generate_date_ranges(start_date)
    start_date = Date.parse(start_date)
    current_date = Date.today
    date_ranges = []

    while start_date <= current_date
      end_date = Date.new(start_date.year, start_date.month, -1)
      date_ranges << {
        start_date: start_date.strftime('%Y-%m-%d'),
        end_date: end_date.strftime('%Y-%m-%d')
      }
      start_date = start_date.next_month
    end

    date_ranges
  end

  # Group and sum downloads by file URL
  def group_by_and_sum(entries)
    entries.group_by { |entry| entry[:url] }.map do |url, items|
      { url: url, downloads: items.sum { |item| item[:downloads].to_i } }
    end
  end

  # Read legacy Chartable downloads from file
  def chartable_downloads
    JSON.parse(File.read('legacy/chartable_downloads.json')).map(&:symbolize_keys)
  end
end
