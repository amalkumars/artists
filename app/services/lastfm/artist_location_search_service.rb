# Lastfm
module Lastfm
  # ArtistLocationSearchService
  # This class is the base of Arist search based on location
  class ArtistLocationSearchService
    # This method initializes ArtistLocationService with
    # country, page, limit and api
    # => country - For with loaction the search is carried out for
    # => page - It represents with page we are accessing in the search API
    # => limit - It represents number of results the API should return
    def initialize(country, page = 1, limit = 5)
      @country = country
      @page = page
      @limit = limit
      @url = api_url
    end

    # This methods triggers the API call to LastFmServer using HttpService (GET)
    # Gets the response in json format
    # A new output hash is build and returned based on the json response
    # => E.g { artists: [{..}], page: 1, total: 'total records in LastFM DB'}
    # Method retuns nil
    # => in case of API Exception and topartists key is not found in the reponse
    def find
      service = HttpService.new
      resp = service.http_get(@url)
      return resp.symbolize_keys unless resp['topartists']
      build_artists_response(resp)
    end

    private

    # This method creates an object of LastFm::ApiService
    # => calls the location_search_api method
    # => and returns the LastFm location based artist search API end point
    def api_url
      service = Lastfm::ApiService.new
      service.location_search_api(@country, @page, @limit)
    end

    def build_artists_response(resp)
      artists = []
      resp['topartists']['artist'].each do |artist|
        artists << build_artist_object(artist)
      end
      { artists: artists,
        page: resp['topartists']['@attr']['page'],
        total: resp['topartists']['@attr']['total'] }
    end

    def build_artist_object(artist)
      artist['image'] = change_image_hash_keys(artist['image'])
      Artist.new(artist)
    end

    # This method changes the image hash key name in the LastFM API response
    # This is done to map ArtistImage model  attributes
    # => we are changing #text to image_url and size to image_size
    # => In case of any exception we return a empty array
    def change_image_hash_keys(image_hash)
      mapping = { '#text' => 'image_url', 'size' => 'image_size' }
      image_hash = image_hash.map { |img| img.map { |k, v| [mapping[k] || k, v] }.to_h }
      image_hash
    rescue
      []
    end
  end
end
