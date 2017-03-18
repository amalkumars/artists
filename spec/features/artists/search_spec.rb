require 'rails_helper'
# This feature spec is to test applications entire flow
# User searches artists based on country
# User gets a list of all artists
# User can select an artist to see this top tracks
describe 'the location based artist search', type: :feature do
  context 'when keyword is blank' do
    it 'will show no results found' do
      # When user searches without a country name our method is expected to return
      # => 'No Records Found.' message
      VCR.use_cassette('feature_artists_search_blank') do
        visit '/artists/search'
        fill_in 'common-search', with: ''
        click_button 'Search'
        expect(page).to have_content 'No Records Found.'
      end
    end
  end

  context 'when keyword is a valid country' do
    it 'will show artists' do
      # When user enters a valid country name our method is expected to return
      # => List of artists and links to their Top tracks page.
      VCR.use_cassette('feature_artists_search_valid') do
        visit '/artists/search'
        fill_in 'common-search', with: 'spain'
        click_button 'Search'
        expect(page).to have_content 'David Bowie'
        expect(page).to have_content 'Listeners'
        expect(page).to have_content 'Public Profile'
        have_link('David Bowie', href: '/artists/5441c29d-3602-4898-b1a1-b77fa23b8e50/tracks')
      end
    end

    it 'navigate to top artists listing page' do
      # From search results page user can navigate to top tracks of an aritsit
      allow_any_instance_of(Lastfm::ArtistTopTracksService).to receive(:find).and_return({ tracks: [ ArtistTrack.new({
        name: "Ziggy Stardust",
        playcount: "4228918",
        listeners: "715147",
        mbid: "b1b29af7-2190-4d0f-9aa8-fe397105679c",
        url: "https://www.last.fm/music/David+Bowie/_/Ziggy+Stardust"
        })] })
      VCR.use_cassette('feature_artists_search_valid') do
        visit '/artists/search'
        fill_in 'common-search', with: 'spain'
        click_button 'Search'
        click_link('David Bowie')
        expect(page).to have_content 'Ziggy Stardust'
      end
    end
  end

  context 'when keyword is a invalid country' do
    it 'will show no results found' do
      # When user searches an invalid country name our method is expected to return
      # => 'country param invalid' message
      VCR.use_cassette('feature_artists_search_invalid') do
        visit '/artists/search'
        fill_in 'common-search', with: 'xxx222@'
        click_button 'Search'
        expect(page).to have_content 'country param invalid'
      end
    end
  end
end
