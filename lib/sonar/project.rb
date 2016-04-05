# encoding: utf-8

module Sonar
  module Project
    CREATE_PROJECT_ENDPOINT = "/api/projects/create"

    # Validates user and pass authentication
    # @param name [String] Name of project
    # @param key [String] Key of project
    # @param branch [String] optional
    # @param format [String] default: json | xml
    # @return [Hashie::Mash] with methods `valid` and `valid?`
    def create_project(name:, key:, branch: nil, format: "json")
      params = {}
      params[:name] = name
      params[:key] = key
      params[:format] = format
      params[:branch] = branch unless branch.nil?

      post(CREATE_PROJECT_ENDPOINT, params)
    end
  end
end
