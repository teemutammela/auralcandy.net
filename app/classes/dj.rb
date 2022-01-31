# frozen_string_literal: true

class DJ
  # NOTE! Corresponding content model ID is 'author', not 'dj'. Easy to miss and potential WTF :)

  # Accessible properties
  attr_accessor :handle, :name

  # Initialize properties
  def initialize(entry)
    @handle = entry.fields[:handle]
    @name   = entry.fields[:name]
  end
end
