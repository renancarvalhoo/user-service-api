class AccountKeyServiceClient
  attr_reader :http_method, :endpoint, :params

  ACCOUNT_KEY_SERVICE_URL = ENV['ACCOUNT_KEY_SERVICE_URL'].freeze

  def initialize(http_method, endpoint, params)
    @http_method = http_method
    @endpoint    = endpoint
    @params      = params
  end

  def request
    client = Faraday.new(ACCOUNT_KEY_SERVICE_URL) do |connection|
      connection.request :url_encoded
      connection.adapter Faraday.default_adapter
    end
    response = client.public_send(http_method, endpoint, params.to_json)

    Oj.load(response.body)
  end
end
