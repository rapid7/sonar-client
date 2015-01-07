# encoding: utf-8

require 'thor'
require 'sonar/cli/rcfile'
require 'awesome_print'

module Sonar
  class CLI < Thor

    class_option 'profile', aliases: '-P', type: :string, default: File.join(File.expand_path('~'), Sonar::RCFile::FILENAME),
      desc: 'Path to Sonar RC file', banner: 'FILE'

    def initialize(*)
      @rcfile = Sonar::RCFile.instance.load_file
      @client = Sonar::Client.new(email: @rcfile["email"], access_token: @rcfile["access_token"], api_url: @rcfile["api_url"])
      super
    end

    # TODO add a way to set config

    desc 'profile', 'Display the current profile from sonar.rc'
    def profile
      ap @rcfile
    end

    desc 'usage', 'Display API usage for current user.'
    def usage
      ap @client.usage
    end

    desc 'search [QUERY TYPE] [QUERY TERM]', 'Search anything from Sonar.'
    def search(type, term)
      @query = {}
      @query[type.to_sym] = term
      ap @client.search(@query)
    end

    desc 'types', 'List all Sonar query types.'
    def types
      ap Search::QUERY_TYPES_MAP
    end

    desc 'config', 'Update Sonar config file'
    def config
    end
  end
end
