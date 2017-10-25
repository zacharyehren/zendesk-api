require 'rest-client'
class ZD_Request

  def initialize
    @base_url = "https://travelingyeti.zendesk.com/api/v2"
    @token = ENV["ZENDESK_TOKEN"]
  end

  def get_comments(id)
    @id = id
    response = RestClient::Request.execute(
    method: :get,
    url: '#{@base_url}/tickets/#{@id}/comments',
    headers: {
          'Authorization': 'Basic thetravelingyeti@gmail.com/token:#{@token}'
        }
    )
    JSON.parse(response.body)
  end

end
