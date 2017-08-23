require 'test_helper'

class ClientTest < Minitest::Test
  OauthDouble = Struct.new(:responses) do
    def fetch_protected_resource(options = {})
      key = options.values_at(:method, :uri)
      unless responses.key?(key)
        raise ArgumentError, "Unmocked request being made to #{key.inspect}"
      end
      responses[key]
    end
  end

  ResponseDouble = Struct.new(:body, :status) do
    def self.build(raw = { 'ping' => 'pong' }, status = 200)
      new(JSON.dump(raw), status)
    end

    def to_hash
      { reason_phrase: 'Not found' }
    end
  end

  def test_get
    client = build_client([:get, '/account'] => ResponseDouble.build)
    assert_equal 'pong', client.get('/account')['ping']
  end

  def test_get_with_params
    client = build_client([:get, '/account?foo=bar'] => ResponseDouble.build)
    assert_equal 'pong', client.get('/account', foo: 'bar')['ping']
  end

  def test_post
    client = build_client([:post, '/account'] => ResponseDouble.build)
    assert_equal 'pong', client.post('/account')['ping']
  end

  def test_post_with_params
    client = build_client([:post, '/account'] => ResponseDouble.build)
    assert_equal 'pong', client.post('/account', foo: 'bar')['ping']
  end

  def test_put
    client = build_client([:put, '/account'] => ResponseDouble.build)
    assert_equal 'pong', client.put('/account')['ping']
  end

  def test_delete
    client = build_client([:delete, '/account'] => ResponseDouble.build)
    assert_equal 'pong', client.delete('/account')['ping']
  end

  def test_bad_response
    response = ResponseDouble.build({ 'ping' => 'pong' }, 404)
    client = build_client([:get, '/account'] => response)
    assert_raises StackPath::APIError do
      client.get('/account')
    end
  end

  private

  def build_client(responses = {})
    client = StackPath.build_client
    client.instance_variable_set(:@base_url, '')
    client.instance_variable_set(:@oauth_client, OauthDouble.new(responses))
    client
  end
end
