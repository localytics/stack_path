module StackPath
  class Error < StandardError; end

  class Client
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

    def get(path, params = {})
      path = "#{path}?#{URI.encode_www_form(params)}" if params.any?
      request(:get, path)
    end

    def post(path, params = {})
      request(:post, path, params)
    end

    def put(path, params = {})
      request(:put, path, params)
    end

    def delete(path, params = {})
      request(:delete, path, params)
    end

    private

    def request(method, path, params = {})
      options = {
        method: method,
        uri: "#{base_url}#{path}",
        headers: HEADERS
      }
      options[:body] = JSON.dump(params) if params.any?

      response = oauth_client.fetch_protected_resource(options)
      if response.status != 200
        raise Error, "Error requesting #{path}: " \
          "#{response.to_hash[:reason_phrase]}"
      end

      JSON.parse(response.body)
    end
  end
end
