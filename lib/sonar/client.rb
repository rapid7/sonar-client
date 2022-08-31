# encoding: utf-8
require 'faraday'
require 'faraday/follow_redirects'
require 'faraday/rashify'
require 'forwardable'
require 'sonar/request'
require 'sonar/search'
require 'sonar/user'
require 'sonar/cli/cli'
require 'sonar/registration'

module Sonar
  class Client
    extend Forwardable

    include Request
    include Search
    include User
    include Registration

    attr_accessor :api_url, :api_version, :access_token, :email

    ##
    # Create a new Sonar::Client object
    #
    # @params options[Hash]
    def initialize(options = {})
      @api_url        = options.fetch(:api_url, default_api_url)
      @api_version    = options.fetch(:api_version, default_api_version )
      @access_token   = options.fetch(:access_token, default_access_token)
      @email          = options.fetch(:email, default_email)
    end

    ##
    # Create a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      params = {}
      @conn = Faraday.new(url: api_url, params: params, headers: default_headers, ssl: { verify: true }) do |faraday|
        faraday.use Faraday::FollowRedirects::Middleware
        faraday.use Faraday::Rashify::Middleware
        faraday.request :json

        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
      @conn.headers['X-Sonar-Token'] = access_token
      @conn.headers['X-Sonar-Email'] = email
      @conn
    end

    ##
    # Generic GET of Sonar search Objects
    def get_search_endpoint(type, params = {})
      url = "/api/#{api_version}/search/#{type}"
      if params[:limit]
        RequestIterator.new(url, connection, params)
      else
        get(url, params)
      end
    end

    ##
    # Generic GET of Sonar Objects
    def get_endpoint(type, params = {})
      url = "/api/#{api_version}/#{type}"
      get(url, params)
    end

    ##
    # Generic POST to Sonar
    def post_to_sonar(type, params = {})
      url = "/api/#{api_version}/#{type}"
      post(url, params)
    end

    private

    # Returns the default value for the api url
    #
    # @return [String] the URL for the Sonar API
    def default_api_url
      begin
        Sonar.api_url
      rescue NoMethodError
        'https://sonar.labs.rapid7.com'
      end
    end

    # Returns the default value for the api version
    #
    # @return [String] the Sonar API version to use
    def default_api_version
      begin
        Sonar.api_version || 'v2'
      rescue NoMethodError
        'v2'
      end
    end

    # Returns the default value for the access token
    #
    # @return [String] if {Sonar} has a value configured
    # @return [nil]
    def default_access_token
      begin
        Sonar.access_token
      rescue NoMethodError
        ''
      end
    end

    # Returns the default value for the email address
    #
    # @return [String] if {Sonar} has a value configured
    # @return [nil]
    def default_email
      begin
        Sonar.email
      rescue NoMethodError
        ''
      end
    end

    def default_headers
      {
        accept: 'application/json',
        content_type: 'application/json',
        user_agent: "Sonar #{Sonar::VERSION} Ruby Gem"
      }
    end
  end
end
