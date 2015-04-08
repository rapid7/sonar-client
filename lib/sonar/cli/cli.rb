# encoding: utf-8

require 'thor'
require 'sonar/cli/rcfile'
require 'awesome_print'

module Sonar
  class CLI < Thor
    class_option 'profile', aliases: '-P', type: :string, default: File.join(File.expand_path('~'), Sonar::RCFile::FILENAME),
                            desc: 'Path to Sonar RC file', banner: 'FILE'
    class_option 'format', type: :string, desc: 'Flat JSON or pretty printed [flat/pretty]'

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
      @client.search(@query).each do |data|
        print_json(cleanup_data(data), options['format'])
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
      else
        # TODO: use a faster JSON generator?
        puts(json.to_json)
      end
    end

    # Clean up whitespace and parse JSON values in responses
    def cleanup_data(data)
      ndata = {}
      if data[0] != 'collection'
        return data
      end

      ncoll = []

      data[1].each do |item|
        nitem = {}
        item.each_pair do |k,v|

          # Purge whitespace within values
          nval = v.kind_of?(::String) ? v.strip : v
          nkey = k.strip

          # Parse JSON values
          if nval && nval.index('{') == 0
            nval = JSON.parse(nval) rescue nval
          end

          nitem[nkey] = nval
        end
        ncoll << nitem
      end
      [ data[0], ncoll ]
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
