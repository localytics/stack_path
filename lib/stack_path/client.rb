module StackPath
  # Represents an error in the response from StackPath
  class APIError < StandardError; end

  # An API client that allows querying StackPath
  class Client
    # The constant headers that are sent with each request
    HEADERS = {
      'User-Agent' => 'Ruby StackPath CDN API Client',
      'Content-Type' => 'application/json'
    }.freeze

    attr_reader :base_url, :oauth_client

    def initialize(options = {})
      @base_url = "https://api.stackpath.com/v1/#{options[:company_alias]}"
      @oauth_client =
        Signet::OAuth1::Client.new(
          client_credential_key: options[:client_key],
          client_credential_secret: options[:client_secret],
          two_legged: true
        )
    end

    # Send a GET request to the StackPath API
    def get(path, params = {})
      path = "#{path}?#{URI.encode_www_form(params)}" if params.any?
      request(:get, path)
    end

    # Send a POST request to the StackPath API
    def post(path, params = {})
      request(:post, path, params)
    end

    # Send a PUT request to the StackPath API
    def put(path, params = {})
      request(:put, path, params)
    end

    # Send a DELETE request to the StackPath API
    def delete(path, params = {})
      request(:delete, path, params)
    end

    private

    def response_from(options)
      response = oauth_client.fetch_protected_resource(options)
      if response.status != 200
        raise APIError, "Error requesting #{path}: " \
          "#{response.to_hash[:reason_phrase]}"
      end
      response
    end

    def request(method, path, params = {})
      options = {
        method: method,
        uri: "#{base_url}#{path}",
        headers: HEADERS
      }
      options[:body] = JSON.dump(params) if params.any?
      JSON.parse(response_from(options).body)
    end
  end
end
