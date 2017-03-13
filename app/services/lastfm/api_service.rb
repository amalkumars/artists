module Lastfm
  # This class is used to generate various API end points to LastFM
  class ApiService
    # This initializes the api service with base_url, api_key and format
    def initialize
      @base_url = FM_BASE_URL
      @api_key = FM_API_KEY
      @format = 'json'
    end

    # This method returns the API url for location based artist search
    # E.g: http://ws.audioscrobbler.com/2.0/?api_key=xx&country=spain
    #      &format=json&limit=5&method=geo.gettopartists&page=5
    def location_search_api(country, page, limit)
      @base_url + FM_LOCATION_SEARCH_PATH +
        "&country=#{country}" \
        "&api_key=#{@api_key}" \
        "&page=#{page}" \
        "&limit=#{limit}" \
        "&format=#{@format}"
    end

    # This method returns the API url for top tracks of an artist
    # E.g: http://ws.audioscrobbler.com/2.0/?api_key=xxx&mbid=MBID
    #      &format=json&method=artist.getTopTracks
    def top_tracks_api(mbid)
      @base_url + FM_TOP_TRACKS_PATH +
        "&mbid=#{mbid}" \
        "&api_key=#{@api_key}" \
        "&format=#{@format}"
    end
  end
end
