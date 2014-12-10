# encoding: utf-8

module Sonar
  class RCFile
    attr_reader :path
    FILENAME = 'sonar.rc'

    def initialize
      @path = File.join(File.expand_path('~'), FILENAME)
      @data = load_file
    end

    def load_file
      require 'yaml'
      YAML.load_file(@path)
    end
  end
end
