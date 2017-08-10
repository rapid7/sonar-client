# encoding: utf-8

module Sonar
  module Search

    # Allow IP queries to be in the form of "1.", "1.2.", "1.2.3.", and "1.2.3.4"
    IS_IP = /^(\d{1,3}\.|\d{1,3}\.\d{1,3}\.|\d{1,3}\.\d{1,3}\.\d{1,3}\.|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/

    # Implemented search query types
    QUERY_TYPES = [
      { name: 'certificate', description: 'Certificate lookup', input: 'sha' },
      { name: 'certips', description: 'Certificate to IPs', input: 'sha' },
      { name: 'rdns', description: 'IP to Reverse DNS Lookup or DNS Lookup to IP', input: 'ip' },
      { name: 'fdns', description: 'Domains to IP or IPs to Domain', input: 'domain' },
      { name: 'ipcerts', description: 'IP to Certificates', input: 'ip' },
      { name: 'namecerts', description: 'Domain to Certificates', input: 'domain' },
      { name: 'links_to', description: 'HTTP References to Domain', input: 'domain' },
      { name: 'ports', description: 'Open Ports', input: 'ip' },
      { name: 'processed', description: 'Open Ports (Processed)', input: 'ip' },
      { name: 'raw', description: 'Open Ports (Raw)', input: 'ip' },
      { name: 'sslcert', description: 'Certificate Details', input: 'sha' },
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

    def handle_search_response(resp)
      errors = 0
      if resp.is_a?(Sonar::Request::RequestIterator)
        resp.each do |data|
          errors += 1 if data.key?('errors') || data.key?('error')
          print_json(cleanup_data(data), options['format'])
        end
      else
        errors += 1 if resp.key?('errors') || resp.key?('error')
        print_json(cleanup_data(resp), options['format'])
      end

      raise Search::SearchError.new("Encountered #{errors} errors while searching") if errors > 0
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
