# encoding: utf-8
require 'faraday'
require 'faraday_middleware'
require 'forwardable'
require 'sonar/request'
require 'sonar/certificate'
require 'sonar/search'
require 'sonar/user'
require 'sonar/user_group'
require 'sonar/project'
require 'sonar/cli/cli'
require 'sonar/registration'

module Sonar
  class Client
    class ConnectionFailed < StandardError; end

    extend Forwardable

    include Request
    include Certificate
    include Search
    include User
    include UserGroup
    include Project
    include Registration

    attr_accessor :api_url, :api_version, :access_token, :email, :pass, :debug, :ssl_verify

    ##
    # Create a new Sonar::Client object
    #
    # @params options[Hash]
    def initialize(options = {})
      @api_url        = options.fetch(:api_url, default_api_url)
      @api_version    = options.fetch(:api_version, default_api_version )
      @access_token   = options.fetch(:access_token, default_access_token)
      @email          = options.fetch(:email, default_email)
      @pass           = options.fetch(:pass, default_email)
      @debug          = options.fetch(:debug, default_email)
      @ssl_verify     = options.fetch(:ssl_verify, default_ssl_verify)
    end

    ##
    # Create a Faraday::Connection object
    # @params options [Hash] :connection_type, :basic_auth
    # @return [Faraday::Connection]
    def connection(options)
      connection_type = options[:connection_type] || :token

      options.delete :connection_type

      case connection_type
      when :token then token_connection
      when :basic_authenticated
        user = options[:basic_auth][:user]
        pass = options[:basic_auth][:pass]

        options.delete :basic_auth

        basic_authenticated_connection(user, pass)
      else
        fail ConnectionFailed, "unexpected connection type '#{connection_type}' provided"
      end
    end

    ##
    # Create a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def token_connection
      params = {}
      @conn = Faraday.new(url: api_url, params: params, headers: default_headers, ssl: { verify: @ssl_verify }) do |builder|
        builder.use FaradayMiddleware::Mashify
        builder.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
        builder.use FaradayMiddleware::FollowRedirects
        builder.use Faraday::Response::Logger if @debug
        builder.adapter Faraday.default_adapter
      end
      @conn.headers['X-Sonar-Token'] = access_token
      @conn.headers['X-Sonar-Email'] = email
      @conn
    end

    # Connect to sonar using basic authentication
    # @param user [String]
    # @param pass [String]
    # @return [Faraday::Connection]
    def basic_authenticated_connection(user, pass)
      Faraday.new(url: api_url, headers: default_headers, ssl: { verify: @ssl_verify }) do |builder|
        builder.use FaradayMiddleware::Mashify
        builder.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
        builder.use FaradayMiddleware::FollowRedirects
        builder.use Faraday::Request::BasicAuthentication, user, pass
        builder.use Faraday::Response::Logger if @debug
        builder.adapter Faraday.default_adapter
      end
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

    def default_ssl_verify
      begin
        Sonar.ssl_verify
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

    def basic_authenticated_options
      {
        connection_type: :basic_authenticated,
        basic_auth: {
          user: @email,
          pass: @pass
        }
      }
    end
  end
end
