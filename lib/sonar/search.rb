# encoding: utf-8

module Sonar
  module Search

    # Allow IP queries to be in the form of "1.", "1.2.", "1.2.3.", and "1.2.3.4"
    IS_IP = /^(\d{1,3}\.|\d{1,3}\.\d{1,3}\.|\d{1,3}\.\d{1,3}\.\d{1,3}\.|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/

    # Implemented search query types
    QUERY_TYPES = [
      { name: 'fdns', description: 'Domains to IP or IPs to Domain', input: 'domain' },
      { name: 'ports', description: 'Open Ports', input: 'ip' },
      { name: 'all', description: 'Search all appropriate search types for an IP or domain', input: 'all' }
    ]

    ##
    # Generic exception for errors encountered while searching
    ##
    class SearchError < StandardError
    end

    def ip_search_type_names
      ip_search_types.map { |type| type[:name] }
    end

    def domain_search_type_names
      domain_search_types.map { |type| type[:name] }
    end

    def ip_search_types
      QUERY_TYPES.select { |type| type[:input] == 'ip' }
    end

    def domain_search_types
      QUERY_TYPES.select { |type| type[:input] == 'domain' }
    end

    def query_type_names
      QUERY_TYPES.map { |type| type[:name] }
    end

    ##
    # Get search
    #
    # params take in search type as key and query as value
    # {fdns: 'rapid7.com'}
    #
    # @return [Hashie::Mash] with response of search
    def search(params = {})
      type_query = params.select { |k, _v| query_type_names.include?(k.to_s) }.first
      fail ArgumentError, "The query type provided is invalid or not yet implemented." unless type_query
      type = type_query[0].to_sym
      params[:q] = type_query[1]
      params = extract_params(params)
      get_search_endpoint(type, params)
    end
  end
end
