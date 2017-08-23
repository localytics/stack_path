require 'json'
require 'signet/oauth_1/client'
require 'uri'

require 'stack_path/client'
require 'stack_path/version'

# A package for querying the StackPath API
module StackPath
  # Build a new Client with the given options and return it
  def self.build_client(options = {})
    Client.new(options)
  end
end
