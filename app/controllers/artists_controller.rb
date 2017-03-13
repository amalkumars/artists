# ArtistsController
class ArtistsController < ApplicationController
  include PaginationConcern

  # Landing page to search artists
  def index
  end

  # /artists/search
  # The method carries out the search action
  # creates an object of ArtistLocationSearchService and call find method
  # @artists - is the list of artists in the country
  # @error_message - contains the message to be displayed in case of exception
  # pagination of @artists is done using paginate_results method (in concern)
  def search
    keyword = params[:keyword]
    return if keyword.blank?
    lastfm = Lastfm::ArtistLocationSearchService.new(keyword, params[:page])
    results = lastfm.find
    @error_message = results[:message] if results[:message].present?
    @artists = paginate_results(results[:artists],
                                results[:page],
                                results[:total]) if results[:artists].present?
  end
end
