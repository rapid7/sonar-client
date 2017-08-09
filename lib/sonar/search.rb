# encoding: utf-8

module Sonar
  module Search
    # Implemented search query types
    QUERY_TYPES_MAP = {
      'certificate' => 'Certificate lookup',
      'certips'     => 'Certificate to IPs',
      'rdns'        => 'IP to Reverse DNS Lookup or DNS Lookup to IP',
      'fdns'        => 'Domains to IP or IPs to Domain',
      'ipcerts'     => 'IP to Certificates',
      'namecerts'   => 'Domain to Certificates',
      'links_to'    => 'HTTP References to Domain',
      'ports'       => 'Open Ports',
      'processed'   => 'Open Ports (Processed)',
      'raw'         => 'Open Ports (Raw)',
      'sslcert'     => 'Certificate Details',
    }

    ##
    # Generic exception for errors encountered while searching
    ##
    class SearchError < StandardError
    end

    ##
    # Get search
    #
    # params take in search type as key and query as value
    # {fdns: 'rapid7.com'}
    #
    # @return [Hashie::Mash] with response of search
    def search(params = {})
      type_query = params.select { |k, _v| QUERY_TYPES_MAP.keys.include?(k.to_s) }.first
      fail ArgumentError, "The query type provided is invalid or not yet implemented." unless type_query
      type = type_query[0].to_sym
      params[:q] = type_query[1]
      params = extract_params(params)
      get_search_endpoint(type, params)
    end
  end
end
