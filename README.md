# StackPath

A Ruby client for the [StackPath CDN](https://www.stackpath.com) API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stack_path'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stack_path

## Usage

First, create a client:

```ruby
client =
  StackPath.build_client(
    company_alias: '...',
    client_key: '...',
    client_secret: '...'
  )
```

then you can use it to hit endpoints:

```ruby
client.get('/account')
# => {"code"=>200, "data"=>{"account"=>{"id"=>"...", "name"=>"...", "alias"=>"...", ...}}}
```

You can also use the `Client#post`, `#put`, and `#delete` methods. Each of them take a path as the first argument and an optional `params` hash as the second argument.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/localytics/stack_path.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
