# encoding: utf-8

require 'thor'
require 'sonar/cli/rcfile'
require 'awesome_print'

module Sonar
  class CLI < Thor
    class_option 'profile', aliases: '-P', type: :string, default: File.join(File.expand_path('~'), Sonar::RCFile::FILENAME),
                            desc: 'Path to Sonar RC file', banner: 'FILE'
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

    desc 'search [QUERY TYPE] [QUERY TERM]', 'Search anything from Sonars'
    method_option 'record_limit', type: :numeric, aliases: '-n', desc: 'Maximum number of records to fetch'
    def search(type, term)
      @query = {}
      @query[type.to_sym] = term
      @query[:limit] = options['record_limit']
      resp = @client.search(@query)

      if resp.is_a?(Sonar::Request::RequestIterator)
        resp.each do |data|
          print_json(cleanup_data(data), options['format'])
        end
      else
        print_json(cleanup_data(resp), options['format'])
      end
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

    def print_json(json, format)
      case format
      when 'pretty'
        ap(json)
      when 'lines'
        if json.has_key?('collection')
          json['collection'].each { |l| puts l.to_json }
        else
          puts 'Could not parse the response into lines.'
        end
      else
        # TODO: use a faster JSON generator?
        puts(json.to_json)
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
