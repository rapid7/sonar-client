require "faraday"
require "sonar/cli/cli"
require "sonar/client"
require "sonar/version"
require "sonar/registration"

module Sonar
  class << self
    attr_accessor :api_url, :api_version, :access_token, :email

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
    end
  end
end
