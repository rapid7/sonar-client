sonar-client
===============

Ruby API Wrapper and CLI for [Sonar](https://sonar.labs.rapid7.com)

[![Gem Version](https://badge.fury.io/rb/sonar-client.svg)](http://badge.fury.io/rb/sonar-client)
[![Build Status](https://travis-ci.org/rapid7/sonar-client.svg?branch=master)](https://travis-ci.org/rapid7/sonar-client)

## Installation

Install the gem by running

    gem install sonar-client

or add this line to your application's Gemfile:

    gem 'sonar-client'

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

## Running the specs

Until they're mocked, specs are run against a live API, either production, staging, or localhost (development).  The config in `spec/spec_helper.rb` requires several credentials to be set as environment variables to make requests.  Consider adding this to your `~/.bashrc` or export the variables before running the specs:

```
# Sonar config
export SONAR_TOKEN=asldkstokenalskdjf
export SONAR_API_URL=http://sonar.labs.rapid7.com/
export SONAR_EMAIL=youremail@example.com
```

Once you have the variables set, `rspec spec` will run all the specs.

## CLI dev setup

From the project root directory
```
$ rake install
sonar-client 0.0.1 built to pkg/sonar-client-0.0.1.gem.
sonar-client (0.0.1) installed.
$ sonar
```

On the first run, sonar will setup a sonar.rc config file in your user folder.  Run `sonar config` to view the full path to your config file.  Here's what your file will look like when it's first created:
```
email: YOUR_EMAIL
access_token: SONAR_TOKEN
api_url: https://sonar.labs.rapid7.com
format: flat
record_limit: 10000
```
Replace YOUR_EMAIL with the email you used to register on the [Sonar website](https://sonar.labs.rapid7.com).  Replace SONAR_TOKEN with your API token found on the [Settings page](https://sonar.labs.rapid7.com/users/edit) of the Sonar website.  The format option can either pretty-print the return JSON or display it in a flat output (by default).  The record limit is the maximum number of records to return for a query.  Responses are returned in 1000 record chunks that are streamed into the output to avoid API timeouts.  Enclosing quotes around these two settings are not needed.  These configurations can always be overwritten for a single command line query by specifying the option and argument: `--format pretty`.

## CLI usage

Typing `sonar help` will list all the available commands. You can type `sonar help TASK` to get help for a specific command.  If running locally from the root project directory, you may need to prefix `sonar` commands with `bundle exec`.  A rdns search command might look like `bundle exec sonar search rdns .rapid7.com`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
