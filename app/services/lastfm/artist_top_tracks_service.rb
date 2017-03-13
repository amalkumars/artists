# Lastfm
module Lastfm
  # ArtistTopTracksService
  # This class is the base of Artist tracks features
  class ArtistTopTracksService
    # This method initializes ArtistTopTracksService with mbid and api
    # mbid - The musicbrainz id for the artist
    def initialize(mbid = nil)
      @mbid = mbid
      @url = api_url
    end

    def find
      service = HttpService.new
      resp = service.http_get(@url)
      return resp.symbolize_keys unless resp['toptracks']
      tracks = []
      resp['toptracks']['track'].each do |track|
        tracks << build_track_object(track)
      end
      { tracks: tracks }
    end

    private

    # This method creates an object of LastFm::ApiService
    # => calls the top_tracks_api method
    # => and returns the LastFm artists top tracks search API end point
    def api_url
      service = Lastfm::ApiService.new
      service.top_tracks_api(@mbid)
    end

    def build_track_object(track)
      ArtistTrack.new(track)
    end
  end
end
