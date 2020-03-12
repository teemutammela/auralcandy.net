class Brand

  # Accessible properties
  attr_accessor :name, :default, :slug, :tagline, :image_url, :short_description, :long_description, :compatibility, :privacy_policy, :keywords, :email, :phone, :street_address, :zip_code, :locality, :apple_podcasts_url, :google_podcasts_url, :paypal_url

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
    @apple_podcasts_url  = entry.fields[:apple_podcasts_url]
    @google_podcasts_url = entry.fields[:google_podcasts_url]
    @paypal_url          = entry.fields[:paypal_url]

  end

end