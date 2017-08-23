require 'test_helper'

class StackPathTest < Minitest::Test
  def test_build_client
    client = StackPath.build_client
    assert_kind_of StackPath::Client, client
  end
end
