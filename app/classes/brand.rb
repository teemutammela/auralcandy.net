# frozen_string_literal: true

class Brand
  # Accessible properties
  attr_reader :name, :default, :slug, :tagline, :image_url, :short_description, :long_description, :compatibility,
              :privacy_policy, :keywords, :email, :phone, :street_address, :zip_code, :locality, :navigation_menu

  # Initialize properties
  def initialize(entry)
    @name                	= entry.fields[:name]
    @default             	= entry.fields[:default_brand]
    @slug                	= entry.fields[:slug]
    @tagline             	= entry.fields[:tagline]
    @image_url           	= "https:#{entry.fields[:image].url}"
    @short_description   	= entry.fields[:short_description]
    @long_description    	= entry.fields[:long_description]
    @compatibility       	= entry.fields[:compatibility]
    @privacy_policy      	= entry.fields[:privacy_policy]
    @keywords            	= entry.fields[:keywords]
    @email               	= entry.fields[:email]
    @phone               	= entry.fields[:phone]
    @street_address      	= entry.fields[:street_address]
    @zip_code            	= entry.fields[:zip_code]
    @locality            	= entry.fields[:locality]
    @navigation_menu	= entry.fields[:navigation_menu].to_a.map do |navigation_item|
      class_name	= navigation_item.sys[:content_type].id
      class_name[0]	= class_name[0].upcase
      class_name.constantize.new(navigation_item)
    end
  end
end
