# Common helper methods that are used in view files are included here
module ApplicationHelper
  # This method returns medium image of an artist
  # In case of an exception we will be displaying (A) as the image
  def image_url(image)
    medium_image = image.select { |h| h.image_size == 'medium' }.first
    url = medium_image.image_url
    raw('<img class="img-circle" src="' + url + '" alt="User Avatar" />')
  rescue
    raw('<img data-name="A" data-font-size="30" data-height="64"
          data-width="64" class="initialjs-avatar user-image img-circle"/>')
  end

  # This method create a link to the artist top tracks
  # In case of an exception this methods returns Artist name or text 'ARTIST'
  def artist_tracks(artist)
    raw(link_to(artist.name, tracks_artist_path(artist.mbid),
                style: 'color: #ffffff;'))
  rescue
    artist.try(:name) || 'ARTIST'
  end

  # To display the error text
  def display_error_message(message)
    message.present? ? message : 'No Records Found.'
  end
end
