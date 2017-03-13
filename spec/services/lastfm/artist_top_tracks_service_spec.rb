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
      VCR.use_cassette('invalid_mbid') do
        # When the mbid is invalid our method is expected to return
        # => The artist you supplied could not be found message
        subject = described_class.new('5697-')
        expect(subject.find).to include(error: 6,
                                        message: 'The artist you supplied could not be found')
      end
    end

    it 'with valid mbid' do
      VCR.use_cassette('valid_mbid') do
        # when the mbid is valid it is expected to return
        # => an tracks array
        # => having size 50
        # => each track must have name, playcount, listeners, mbid, url
        subject = described_class.new('5441c29d-3602-4898-b1a1-b77fa23b8e50')
        response = subject.find
        expect(response[:tracks]).to be_kind_of(Array)
        expect(response[:tracks].size).to eq(50)
        first_record = response[:tracks].first
        expect(first_record.methods).to include(:name, :url, :listeners, :mbid,
                                                :playcount)
      end
    end
  end
end
