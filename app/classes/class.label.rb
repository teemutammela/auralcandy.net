class Label

  # Accessible properties
  attr_accessor :name, :link_url

  # Initialize properties
  def initialize(entry)

    @name			= entry.fields[:name]
    @link_url	= entry.fields[:link_url]

  end

end