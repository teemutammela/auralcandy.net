class Label

  # Accessible properties
  attr_accessor :name, :link

  # Initialize properties
  def initialize(entry)

    @name = entry.fields[:name]
    @link = entry.fields[:link_url]

  end

end