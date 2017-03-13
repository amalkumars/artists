# Artist Image Model
class ArtistImage
  include Virtus.model

  attribute :image_url, String
  attribute :image_size, String
end
