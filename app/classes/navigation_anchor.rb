# frozen_string_literal: true

class NavigationAnchor
  # Accessible properties
  attr_accessor :name, :description, :link_anchor

  # Initialize properties
  def initialize(entry)
    @name	= entry.fields[:name]
    @description	= entry.fields[:description]
    @link_anchor	= entry.fields[:link_anchor]
  end
end
