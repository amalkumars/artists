require 'rails_helper'
# This spec is to test the HttpService http_get method functionality
# VCR is used to records the API responses to spec/vcr_cassettes folder
describe Lastfm::HttpService do
  describe '#http_get', vcr: true do
    it 'invalid api' do
      # when api key is invalid it is expected to return
      # => Invalid API key - You must be granted a valid key by last.fm message
      VCR.use_cassette('http_get_with_invalid_api_key') do
        url = 'http://ws.audioscrobbler.com/2.0/?method=geo.gettopartists&country=spain&api_key=5&page=1&limit=5&format=json'
        subject = described_class.new
        response = subject.http_get(url)
        expect(response).to include('error' => 10, 'message' => 'Invalid API key - You must be granted a valid key by last.fm')
      end
    end

    it 'invalid method' do
      # when lastFm api method name is invalid it is expected to return
      # => Invalid Method - No method with that name in this package message
      VCR.use_cassette('http_get_with_invalid_method') do
        url = 'http://ws.audioscrobbler.com/2.0/?method=geo.getopartists&country=spain&api_key=294012135d9809c38ac3b9dfae5a17f2&page=1&limit=5&format=json'
        subject = described_class.new
        response = subject.http_get(url)
        expect(response).to include('error' => 3, 'message' => 'Invalid Method - No method with that name in this package')
      end
    end

    it 'invalid url' do
      # when URL is invalid our method is expected to return
      # => Invalid Request message
      VCR.use_cassette('http_get_with_invalid_url') do
        url = 'http://ws..com/2.0/?method=geo.getopartists&format=json'
        subject = described_class.new
        response = subject.http_get(url)
        expect(response).to include('error' => 1, 'message' => 'Invalid Request')
      end
    end
  end
end
