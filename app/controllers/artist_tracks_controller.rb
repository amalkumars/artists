# ArtistTracksController
class ArtistTracksController < ApplicationController
  # This method lists top tracks of an artist
  # /artist/:id/tracks
  # id - is the mbid of the artist
  # @tracks - is the list of top 50 tracks of the artist.
  # @error_message - contains the message to be displayed in case of exception
  def index
    mbid = params[:id]
    return if mbid.blank?
    lastfm = Lastfm::ArtistTopTracksService.new(mbid)
    results = lastfm.find
    @error_message = results[:message] if results[:message].present?
    @tracks = results[:tracks] if results[:tracks].present?
  end
end
