# encoding: utf-8

module Sonar
  module Search

    # Implemented search query types
    QUERY_TYPES = %i(
      certificate
      rdns
      fdns
      links_to
      ipcerts
      certips
      namecerts
      sslcert
      whois_ip
      raw
      processed
      ports
    )

    ##
    # Get search
    #
    # params take in search type as key and query as value
    # {fdns: 'rapid7.com'}
    #
    # @return [Hashie::Mash] with response of search
    def search(params={})
      type_query = params.select {|k,v| QUERY_TYPES.include?(k) }.first
      raise ArgumentError, "The query type provided is invalid or not yet implemented." unless type_query
      type = type_query[0].to_sym
      params[:q] = type_query[1]
      params = extract_params(params)
      get_search_endpoint(type, params)
    end

  end
end
