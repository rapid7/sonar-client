# encoding: utf-8
require 'forwardable'
require 'sonar/request'
require 'sonar/certificate'
require 'sonar/search'
require 'sonar/user'
require 'sonar/cli/cli'

module Sonar
  class Client
    extend Forwardable

    include Request
    include Certificate
    include Search
    include User

    attr_accessor :api_url, :api_version, :access_token, :email

    ##
    # Create a new Sonar::Client object
    #
    # @params options[Hash]
    def initialize(options={})
      @api_url        = options[:api_url]       || Sonar.api_url       || "https://sonar.labs.rapid7.com"
      @api_version    = options[:api_version]   || Sonar.api_version   || "v2"
      @access_token   = options[:access_token]  || Sonar.access_token
      @email          = options[:email]         || Sonar.email
    end

    ##
    # Create a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      params = {}
      @conn = Faraday.new(url: api_url, params: params, headers: default_headers, ssl: {verify: true}) do |faraday|
        faraday.use FaradayMiddleware::Mashify
        faraday.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter Faraday.default_adapter
      end
      @conn.headers['X-Sonar-Token'] = access_token
      @conn.headers['X-Sonar-Email'] = email
      @conn
    end

    ##
    # Generic GET of Sonar search Objects
    def get_search_endpoint(type, params={})
      url = "/api/#{api_version}/search/#{type.to_s}"
      if params[:limit]
        RequestIterator.new(url, connection, params)
      else
        get(url, params)
      end
    end

    ##
    # Generic GET of Sonar Objects
    def get_endpoint(type, params={})
      url = "/api/#{api_version}/#{type.to_s}"
      get(url, params)
    end

    ##
    # Generic POST to Sonar
    def post_to_sonar(type, params={})
      url = "/api/#{api_version}/#{type.to_s}"
      post(url, params)
    end

    private

    def default_headers
      {
        accept: 'application/json',
        content_type: 'application/json',
        user_agent: "Sonar #{Sonar::VERSION} Ruby Gem"
      }
    end

  end
end
