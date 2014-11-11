require 'sonar'
require 'vcr'
require 'simplecov'
require 'simplecov-rcov'
require 'api_matchers'

class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    SimpleCov::Formatter::RcovFormatter.new.format(result)
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
SimpleCov.start do
  add_filter '/vendor'
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/cassette'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
end

RSpec.configure do |c|
  c.include APIMatchers::RSpecMatchers

  c.treat_symbols_as_metadata_keys_with_true_values = true

  #
  # Add gem specific configuration for easy access
  #
  c.before(:each) do
    Sonar.configure do |config|
      unless ENV['SONAR_TOKEN'] && ENV['SONAR_EMAIL']
        raise ArgumentError, "Please configure Sonar for testing by setting SONAR_TOKEN, SONAR_EMAIL, and SONAR_API_URL in your environment."
      end
      config.api_url          = ENV['SONAR_API_URL'] || 'http://localhost:3000'
      config.api_version      = 'v2'
      config.access_token     = ENV['SONAR_TOKEN']
      config.email            = ENV['SONAR_EMAIL']
    end
  end
end
