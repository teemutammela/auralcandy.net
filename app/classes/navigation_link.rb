# frozen_string_literal: true

class NavigationLink
  # Accessible properties
  attr_accessor :name, :description, :link_url

  # Initialize properties
  def initialize(entry)
    @name	= entry.fields[:name]
    @description	= entry.fields[:description]
    @link_url	= entry.fields[:link_url]
  end
end
