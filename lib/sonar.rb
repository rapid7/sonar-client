require "faraday"
require "faraday_middleware"
require "sonar/cli/cli"
require "sonar/client"
require "sonar/version"
require "sonar/registration"

module Sonar
  class InvalidParameters < StandardError; end

  class << self
    attr_accessor :api_url, :api_version, :access_token, :email, :pass, :debug, :ssl_verify

    ##
    # Configure default
    #
    # @yield Sonar client object
    def configure
      load_defaults
      yield self
      true
    end

    private

    def load_defaults
      self.api_url ||= "https://sonar.labs.rapid7.com"
      self.api_version ||= "v2"
      self.debug ||= false
      self.ssl_verify = true if !self.ssl_verify || !self.ssl_verify.is_a?(FalseClass)
    end
  end
end
