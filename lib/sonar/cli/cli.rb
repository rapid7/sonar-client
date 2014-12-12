# encoding: utf-8

require 'thor'
require 'sonar/cli/rcfile'

module Sonar
  class CLI < Thor

    class_option 'profile', aliases: '-P', type: :string, default: File.join(File.expand_path('~'), Sonar::RCFile::FILENAME),
      desc: 'Path to Sonar RC file', banner: 'FILE'

    def initialize(*)
      @rcfile = Sonar::RCFile.instance.load_file
      @client = Sonar::Client.new(email: @rcfile["email"], access_token: @rcfile["access_token"], api_url: @rcfile["api_url"])
      super
    end

    # TODO add something to set config

    desc 'profile', 'Display the current profile from sonar.rc'
    def profile
      puts @rcfile
    end

    desc 'usage', 'Display API usage for current user.'
    def usage
      puts @client.usage
    end

    desc 'search', 'Search anything from Sonar.'
    def search
      puts @client.search(fdns: '.hp.com')
    end
  end
end
