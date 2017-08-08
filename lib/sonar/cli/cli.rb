# encoding: utf-8

require 'thor'
require 'sonar/cli/rcfile'
require 'sonar/search'
require 'awesome_print'

include Sonar::Search

module Sonar
  class CLI < Thor
    class_option 'format', type: :string, desc: 'Flat JSON, JSON lines, or pretty printed [flat/lines/pretty]'

    def initialize(*)
      @config = Sonar::RCFile.instance.load_file
      @client = Sonar::Client.new(email: @config["email"], access_token: @config["access_token"], api_url: @config["api_url"])
      super
    end

    desc 'profile', 'Display the current profile from sonar.rc'
    def profile
      ap @config
    end

    desc 'usage', 'Display API usage for current user'
    def usage
      ap @client.usage
    end

    desc 'search_all [QUERY TERM]', 'Search all Sonar record types'
    def search_all(term)
      if term =~ IS_IP
        types = ip_search_type_names
      else
        types = domain_search_type_names
      end
      types.each do |type|
        search(type, term) rescue 'Search failed'
      end
    end

    desc 'search [QUERY TYPE] [QUERY TERM]', 'Search anything from Sonars'
    method_option 'record_limit', type: :numeric, aliases: '-n', desc: 'Maximum number of records to fetch'
    method_option 'exact', type: :boolean, aliases: '-e', desc: 'Search for the query string exactly, do not include partial string matches'
    def search(type, term)
      @query = {}
      @query[type.to_sym] = term
      @query[:limit] = options['record_limit']
      @query[:exact] = options['exact']
      resp = @client.search(@query)

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

    desc 'types', 'List all Sonar query types'
    def types
      ap Search::QUERY_TYPES_MAP
    end

    desc 'config', 'Sonar config file location'
    def config
      # TODO: add a way to set config
      puts "Your config file is located at #{RCFile.instance.path}"
    end

    private

    def print_json(data, format)
      case format
      when 'pretty'
        ap(data)
      when 'lines'
        if data.has_key?('collection')
          data['collection'].each { |l| puts l.to_json }
        else
          puts 'WARNING: Could not parse the response into lines, there was no collection.'
          puts data.to_json
        end
      else
        # TODO: use a faster JSON generator?
        puts(data.to_json)
      end
    end

    # Clean up whitespace and parse JSON values in responses
    def cleanup_data(data)
      return data unless data.is_a?(Hash) && data.has_key?('collection')
      data['collection'].each do |item|
        item.each_pair do |k,v|
          # Purge whitespace within values
          v.is_a?(::String) ? v.strip! : v

          # Parse JSON values
          if v.is_a?(Array)
            v.map! do |e|
              e = safe_parse_json(e)
            end
          else
            item[k] = safe_parse_json(v)
          end
        end
      end
      data
    end

    def safe_parse_json(s)
      JSON.parse(s) rescue s
    end

    # Merge Thor options with those stored in sonar.rc file
    # where all default options are set.
    def options
      original_options = super
      user_defaults = @config
      user_defaults.merge(original_options)
    end
  end
end
