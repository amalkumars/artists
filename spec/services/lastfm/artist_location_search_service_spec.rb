require 'rails_helper'
# This spec is to test the ArtistLocationSearchService find method functionality
# VCR is used to records the API responses to spec/vcr_cassettes folder
describe Lastfm::ArtistLocationSearchService do
  describe '#find', vcr: true do
    it 'with country name blank' do
      # When the keyword is blank our method is expected to return
      # => country param invalid message
      VCR.use_cassette('blank_country') do
        subject = described_class.new('', 3)
        expect(subject.find).to include(error: 6,
                                        message: 'country param invalid')
      end
    end

    it 'with invalid country name' do
      VCR.use_cassette('invalid_country') do
        # When the keyword is invalid our method is expected to return
        # => country param invalid
        subject = described_class.new('xxx')
        expect(subject.find).to include(error: 6,
                                        message: 'country param invalid')
      end
    end

    it 'with valid country name' do
      VCR.use_cassette('valid_country') do
        # when the keyword is a valid country name it is expected to return
        # => an artists array
        # => having size 5
        # => page as 1 (first 5 results)
        # => each artist must have name, url, listeners, mbid, streambale and
        #    image as the keys
        subject = described_class.new('spain')
        response = subject.find
        expect(response[:artists]).to be_kind_of(Array)
        expect(response[:artists].size).to eq(5)
        expect(response[:page].to_i).to eq(1)
        first_record = response[:artists].first
        expect(first_record.methods).to include(:name, :url, :listeners, :mbid,
                                                :streamable, :image)
      end
    end

    it 'with valid country name and page number' do
      VCR.use_cassette('valid_country_and_page_number') do
        # when the keyword is a valid country name and page = 3 it is expected to return
        # => an artists array
        # => having size 5
        # => page as 3 (results from 11 to 15)
        # => each artist must have name, url, listeners, mbid, streambale and
        #    image as the keys
        subject = described_class.new('spain', 3)
        response = subject.find
        expect(response[:artists]).to be_kind_of(Array)
        expect(response[:artists].size).to eq(5)
        expect(response[:page].to_i).to eq(3)
        first_record = response[:artists].first
        expect(first_record.methods).to include(:name, :url, :listeners, :mbid,
                                                :streamable, :image)
      end
    end

    it 'with valid country name and out of bounds page number' do
      VCR.use_cassette('valid_country_out_of_bounds_page_number') do
        # when the keyword is a valid country name and page = 6666666 it is expected to return
        # => page param out of bounds (1-1000000) message
        subject = described_class.new('spain', 6_666_666)
        expect(subject.find).to include(error: 6,
                                        message: 'page param out of bounds (1-1000000)')
      end
    end

    it 'with valid country name and invalid page number within bounds' do
      VCR.use_cassette('valid_country_with_invalid_page_and_within_bounds') do
        # when the keyword is a valid country name and page = 6666666 it is expected to return
        # => an empty artists array
        subject = described_class.new('spain', 90_600)
        response = subject.find
        expect(response[:artists].size).to eq(0)
      end
    end

    it 'with valid country and invalid api key' do
      VCR.use_cassette('valid_country_and_invalid_api_key') do
        stub_const("FM_API_KEY", 5)
        # when the keyword is a valid country name and invalid api key it is expected to return
        # => Invalid API key - You must be granted a valid key by last.fm
        subject = described_class.new('spain')
        response = subject.find
        expect(subject.find).to include(error: 10,
                                        message: 'Invalid API key - You must be granted a valid key by last.fm')
      end
    end
  end
end
