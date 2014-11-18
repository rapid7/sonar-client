# encoding: utf-8
require 'active_support/core_ext'
require 'multi_json'

module Sonar
  module Request

    def extract_params(params)
      # extract something from Sonar if needed
      params
    end

    def get(path, options={})
      request(:get, path, options)
    end

    def post(path, options={})
      request(:post, path, options)
    end

    def put(path, options={})
      request(:put, path, options)
    end

    def request(method, path, options)
      response = connection.send(method) do |request|
        case method
        when :get
          request.url(path, options)
        when :post, :put
          request.path = path
          request.body = MultiJson.encode(options) unless options.empty?
        end
      end

      response.body
    end

  end
end
