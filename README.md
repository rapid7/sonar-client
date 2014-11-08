# Sonar

Ruby API Wrapper and CLI for [Sonar](https://sonar.labs.rapid7.com)

## Installation

Install the gem by running

    gem install sonar

or add this line to your application's Gemfile:

    gem 'sonar'

And then execute:

    $ bundle install

## Usage

```ruby
    require 'sonar'

    # If you're using Rails 3+, create an initializer
    # config/initializers/sonar.rb
    Sonar.configure do |config|
      config.api_url        = 'https://sonar.labs.rapid7.com/api'
      config.api_version    = 'v2'
    end

    # If you're using straight ruby (no Rails),
    # create a Sonar::Client Object
    options = {
      api_url: 'https://sonar.labs.rapid7.com/api',
      api_version: 'v2',
      access_token: 'DEMO_KEY' # Replace this with your key
    }
    client = Sonar::Client.new options

    # Create a Client Object expecting you have an initializer in place
    # Sonar::Client Object
    client = Sonar::Client.new

    # => Get search
    client.get_search({access_token: "YOUR_ACCESS_TOKEN"})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b features/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
