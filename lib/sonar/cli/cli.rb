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
    method_option :records, type: :numeric, aliases: '-n', desc: 'Maximum number of records to fetch'
    def search(type, term)
      @query = {}
      @query[type.to_sym] = term
      print_json(@client.search(@query), options['format'])
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
        puts(json.to_json)
      end
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
