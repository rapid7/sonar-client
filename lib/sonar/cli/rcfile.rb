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
      end
      puts "Config file setup at: #{@path}"
    end

    def load_file
      unless File.exists?(@path)
        create_file
      end
      YAML.load_file(@path)
    end
  end
end
