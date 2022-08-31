require 'sonar'
require 'active_support'
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
  c.hook_into :faraday
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
end

RSpec.configure do |c|
  c.include APIMatchers::RSpecMatchers

  #
  # Add gem specific configuration for easy access
  #
  c.before(:each) do
    # TODO: move to using a gem like VCR for faking HTTP requests.
    # For now we'll test against the staging server using
    # real creds stored in env.
    Sonar.configure do |config|
      unless ENV['SONAR_TOKEN'] && ENV['SONAR_EMAIL']
        fail ArgumentError, "Please configure Sonar for testing by setting SONAR_TOKEN, SONAR_EMAIL,
          and SONAR_API_URL in your environment."
      end
      config.api_url          = ENV['SONAR_API_URL'] || 'http://localhost:3000'
      config.api_version      = 'v2'
      config.access_token     = ENV['SONAR_TOKEN']
      config.email            = ENV['SONAR_EMAIL']
    end
  end
end

def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end

def fixtures_path
  File.expand_path('../fixtures', __FILE__)
end

def reset_sonar_config
  Sonar.remove_class_variable(:@@api_url) if Sonar.class_variable_defined?(:@@api_url)
  Sonar.remove_class_variable(:@@api_version) if Sonar.class_variable_defined?(:@@api_version)
end
