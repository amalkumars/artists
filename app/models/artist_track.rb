# Artist Track Model
class ArtistTrack
  include Virtus.model

  # Fields are name, playcount, listeners, mbid, url, streamable
  # Field Artist is mapped to Artist Model
  attribute :name, String
  attribute :playcount, String
  attribute :listeners, String
  attribute :mbid, String
  attribute :url, String
  attribute :streamable, String
  attribute :artist, Artist
end
