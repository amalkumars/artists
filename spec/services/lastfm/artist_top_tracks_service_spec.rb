require 'rails_helper'
# This spec is to test the ArtistTopTracksService find method functionality
# VCR is used to records the API responses to spec/vcr_cassettes folder
describe Lastfm::ArtistTopTracksService do
  describe '#find', vcr: true do
    it 'with mbid blank' do
      # When the mbid is blank our method is expected to return
      # => The artist you supplied could not be found message
      VCR.use_cassette('blank_mbid') do
        subject = described_class.new
        expect(subject.find).to include(error: 6,
                                        message: 'The artist you supplied could not be found')
      end
    end

    it 'with invalid mbid' do
      # When the mbid is invalid our method is expected to return
      # => The artist you supplied could not be found message
      VCR.use_cassette('invalid_mbid') do
        subject = described_class.new('5697-')
        expect(subject.find).to include(error: 6,
                                        message: 'The artist you supplied could not be found')
      end
    end

    it 'with valid mbid' do
      # when the mbid is valid it is expected to return
      # => an tracks array
      # => having size 50
      # => each track must have name, playcount, listeners, mbid, url
      VCR.use_cassette('valid_mbid') do
        subject = described_class.new('5441c29d-3602-4898-b1a1-b77fa23b8e50')
        response = subject.find
        expect(response[:tracks]).to be_kind_of(Array)
        expect(response[:tracks].size).to eq(50)
        first_record = response[:tracks].first
        expect(first_record.methods).to include(:name, :url, :listeners, :mbid,
                                                :playcount)
      end
    end

    it 'with invalid api key' do
      # when the mbid is and invalid api key it is expected to return
      # => Invalid API key - You must be granted a valid key by last.fm
      VCR.use_cassette('valid_mbid_and_invalid_api_key') do
        stub_const("FM_API_KEY", 5)
        subject = described_class.new('5441c29d-3602-4898-b1a1-b77fa23b8e50')
        response = subject.find
        expect(subject.find).to include(error: 10,
                                        message: 'Invalid API key - You must be granted a valid key by last.fm')
      end
    end

    it 'invalid top tracks method' do
      # when lastFm top tracks api method name is invalid it is expected to return
      # => Invalid Method - No method with that name in this package message
      VCR.use_cassette('top_tracks_with_invalid_method') do
        stub_const("FM_TOP_TRACKS_PATH", '/2.0/?method=artist.getToTrack')
        subject = described_class.new('5441c29d-3602-4898-b1a1-b77fa23b8e50')
        response = subject.find
        expect(response).to include(error: 3, message: 'Invalid Method - No method with that name in this package')
      end
    end
  end
end
