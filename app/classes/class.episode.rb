class Episode

  # Accessible properties
  attr_accessor :id, :published, :updated, :dj, :title, :slug, :brand, :description, :track_list, :duration, :genre, :labels, :image_url, :audio_url, :file_size

  # Initialize properties
  def initialize(entry)

    @id           = entry.sys[:id]
    @published    = Date.strptime(entry.fields[:release_date].tr("-", ""), "%Y%m%d")
    @updated      = entry.sys[:updated_at]
    @dj           = entry.fields[:dj].to_a.map { |dj| DJ.new(dj) }
    @title        = entry.fields[:title]
    @slug         = entry.fields[:slug]
    @index        = $slugs.index(@slug).to_i
    @brand        = Brand.new(entry.fields[:brand])
    @description  = entry.fields[:description]
    @track_list   = entry.fields[:track_list].to_s.split("\n")
    @duration     = entry.fields[:duration]
    @genre        = entry.fields[:genre].sort
    @labels       = (entry.fields[:label].to_a.map { |label| Label.new(label) }).sort_by(&:name)
    @image_url    = (entry.fields[:image] ? "https:" + entry.fields[:image].url : @brand.image_url)
    @audio_url    = "https:" + entry.fields[:audio].url
    @file_size    = entry.fields[:audio].file.details["size"].to_i

  end

  # Publish date in RFC2822 format
  def published_rfc
    @published.rfc2822
  end

  # Publish date in natural language format
  def published_natural
    @published.strftime("#{@published.day.ordinalize} %B %Y")
  end
  
  # Publish date year
  def published_year
    @published.strftime("%Y")
  end

  # Combine DJs as a single string
  def djs
    (@dj.to_a.map { |dj| dj.handle }).join(", ").sub(/(.*), /,'\1 & ')
  end

  # Combine DJ(s) and title to a single string
  def title_full
    "#{djs} - #{@title}"
  end

  # Episode URL for a given slug
  def create_episode_url(slug)
    (slug ? "#{$base_url}/episodes/#{slug}" : false)
  end

  # Episode langing page URL
  def url
    create_episode_url(@slug)
  end

  # Previous episode URL
  def previous_url
    create_episode_url($slugs[@index-1])
  end

  # Next episode URL
  def next_url
    create_episode_url($slugs[@index+1])
  end

end