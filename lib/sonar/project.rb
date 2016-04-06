# encoding: utf-8

module Sonar
  module Project
    CREATE_ENDPOINT = "/api/projects/create"

    DELETE_ENDPOINT = "/api/projects/delete"
    # Create project
    # @param name [String] Name of project
    # @param key [String] Key of project
    # @param branch [String] optional
    # @param format [String] default: json | xml
    # @return [Hashie::Mash] with methods `valid` and `valid?`
    def create_project(name:, key:, branch: nil, format: "json")
      options = {}
      options[:name] = name
      options[:key] = key
      options[:format] = format
      options[:branch] = branch unless branch.nil?

      post(CREATE_ENDPOINT, options)
    end

    # Delete project
    # @param id [String] project id
    # @param key [String] project key
    # @return [String] ""
    def delete_project(id: nil, key: nil)
      fail Sonar::InvalidParameters, "parameter `id` or `key` must be provided" if id.nil? & key.nil?

      options = basic_authenticated_options
      options[:id] = id unless id.nil?
      options[:key] = key unless key.nil?

      post(DELETE_ENDPOINT, options)
    end
  end
end
