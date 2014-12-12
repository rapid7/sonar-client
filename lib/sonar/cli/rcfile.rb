# encoding: utf-8
require "singleton"

module Sonar
  class RCFile
    include Singleton

    attr_accessor :path
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
