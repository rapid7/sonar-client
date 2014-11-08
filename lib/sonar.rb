require "faraday"
require "faraday_middleware"
require "sonar/client"
require "sonar/version"

directory = File.expand_path(File.dirname(__FILE__))

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
      self.api_url ||= 'https://sonar.labs.rapid7.com/api'
      self.api_version ||= 'v2'
      self.access_token ||= 'ACTUAL_KEY'
    end
  end

end
