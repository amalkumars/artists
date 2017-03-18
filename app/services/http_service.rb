# HTTP Service
# This class handles all the HTTP method calls
class HttpService
  # This method is used to trigger HTTP /GET method
  # returns Invalid Request message if response code is not 200
  # if response code is 200 method parses the JSON response body and returns it
  def http_get(url)
    return invalid_request if url.blank?
    response = Net::HTTP.get_response(URI.parse(url))
    json_response = JSON.parse(response.body)
    json_response
  rescue
    invalid_request
  end

  private

  def invalid_request
    { 'message' => 'Invalid Request', 'error' => 1 }
  end
end
