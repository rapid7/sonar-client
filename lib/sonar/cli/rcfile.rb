# encoding: utf-8
require 'singleton'
require 'yaml'

module Sonar
  class RCFile
    include Singleton

    attr_accessor :path
    FILENAME = 'sonar.rc'

    def initialize
      @path = File.join(File.expand_path('~'), FILENAME)
      @data = load_file
    end

    def create_file
      File.open(@path, 'w') do |f|
        f.puts 'email: YOUR_EMAIL'
        f.puts 'access_token: SONAR_TOKEN'
        f.puts 'api_url: https://sonar.labs.rapid7.com'
        f.puts 'format: flat'
        f.puts 'record_limit: 10000'
      end
      warn = "Please set your email and API token in sonar.rc"
      puts "=" * warn.size
      puts "Config file setup at: #{@path}"
      puts warn
      puts "=" * warn.size
    end

    def load_file
      create_file unless File.exist?(@path)
      YAML.load_file(@path)
    end
  end
end
