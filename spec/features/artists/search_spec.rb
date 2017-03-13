require 'rails_helper'

describe 'the location based artist search', type: :feature do
  context 'when keyword is blank' do
    it 'will show no results found' do
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
  end

  context 'when keyword is a invalid country' do
    it 'will show no results found' do
      VCR.use_cassette('feature_artists_search_invalid') do
        visit '/artists/search'
        fill_in 'common-search', with: 'xxx222@'
        click_button 'Search'
        expect(page).to have_content 'country param invalid'
      end
    end
  end
end
