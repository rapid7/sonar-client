# encoding: utf-8
require 'multi_json'

module Sonar
  module Request
    def extract_params(params)
      # extract something from Sonar if needed
      params
    end

    def get(path, options = {})
      request(:get, path, options)
    end

    def post(path, options = {})
      request(:post, path, options)
    end

    def put(path, options = {})
      request(:put, path, options)
    end

    def request(method, path, options)
      response = connection.send(method) do |request|
        options.delete(:connection)
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

    class RequestIterator
      include Request

      attr_accessor :url, :connection, :params

      def initialize(url, connection, params = {})
        self.url = url
        self.connection = connection
        self.params = params
      end

      def each
        more = true
        records_rcvd = 0
        while more && records_rcvd < params[:limit]
          # TODO: refactor to not pass around the connection
          params[:connection] = connection
          resp = get(url, params)
          params[:iterator_id] = resp.iterator_id
          records_rcvd += resp['collection'].size rescue 0
          more = resp['more']
          yield resp
        end
        params.delete(:iterator_id)
      end
    end
  end
end
