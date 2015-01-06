labs-sonar-ruby
===============

Ruby API Wrapper and CLI for [Sonar](https://sonar.labs.rapid7.com)

## Installation

Install the gem by running

    gem install sonar

or add this line to your application's Gemfile:

    gem 'sonar'

And then execute:

    $ bundle install

## Gem usage

```ruby
    require 'sonar'

    # If you're using Rails 3+, create an initializer
    # config/initializers/sonar.rb
    Sonar.configure do |config|
      config.api_url        = 'https://sonar.labs.rapid7.com'
      config.api_version    = 'v2'
      config.email          = 'email@example.com'
      config.access_token   = 'YOURTOKEN'
    end

    # If you're using straight ruby (no Rails),
    # create a Sonar::Client Object
    options = {
      api_url: 'https://sonar.labs.rapid7.com',
      api_version: 'v2',
      access_token: 'YOURTOKEN',
      email: 'email@example.com'
    }
    client = Sonar::Client.new(options)

    # Create a Client Object expecting you have an initializer in place
    # Sonar::Client Object
    client = Sonar::Client.new

    # Get fdns
    client.search(fdns: 'rapid7.com')
    # => responds with a Hashie object
```

## CLI dev setup

From the project root directory
```
$ rake install
sonar 0.0.1 built to pkg/sonar-0.0.1.gem.
sonar (0.0.1) installed.
$ bundle exec sonar
```

## CLI usage

Typing `sonar help` will list all the available commands. You can type `sonar help TASK` to get help for a specific command.  If running locally from the root project directory, you may need to prefix `sonar` commands with `bundle exec`.  A rdns search command might look like `bundle exec sonar search rdns .rapid7.com`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
