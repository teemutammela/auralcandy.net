class Brand

  # Accessible properties
  attr_accessor :name, :default, :slug, :tagline, :image_url, :short_description, :long_description, :compatibility, :privacy_policy, :keywords, :email, :phone, :street_address, :zip_code, :locality, :itunes_url, :spotify_url, :google_podcasts_url, :mixcloud_url, :merchandise_url

  # Initialize properties
  def initialize(entry)

    @name                = entry.fields[:name]
    @default             = entry.fields[:default_brand]
    @slug                = entry.fields[:slug]
    @tagline             = entry.fields[:tagline]
    @image_url           = "https:" + entry.fields[:image].url
    @short_description   = entry.fields[:short_description]
    @long_description    = entry.fields[:long_description]
    @compatibility       = entry.fields[:compatibility]
    @privacy_policy      = entry.fields[:privacy_policy]
    @keywords            = entry.fields[:keywords]
    @email               = entry.fields[:email]
    @phone               = entry.fields[:phone]
    @street_address      = entry.fields[:street_address]
    @zip_code            = entry.fields[:zip_code]
    @locality            = entry.fields[:locality]
    @itunes_url          = entry.fields[:itunes_url]
    @spotify_url         = entry.fields[:spotify_url]
    @google_podcasts_url = entry.fields[:google_podcasts_url]
    @mixcloud_url        = entry.fields[:mixcloud_url]
    @merchandise_url     = entry.fields[:merchandise_url]

  end

end