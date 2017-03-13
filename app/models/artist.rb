# Artist Model
class Artist
  # Virtus allows you to define attributes on classes, modules or class instance
  # with optional information about types, reader/writer method visibility
  # and coercion behavior.
  include Virtus.model

  # Fields are name, listeners, mbid, url, streamable
  # image is of type array, mapped to ArtistImage Model
  attribute :name, String
  attribute :listeners, String
  attribute :mbid, String
  attribute :url, String
  attribute :streamable, String
  attribute :image, Array[ArtistImage]
end
