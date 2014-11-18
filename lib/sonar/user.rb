# encoding: utf-8

module Sonar
  module User
    def usage
      url = "/api/#{Sonar.api_version}/search/usage"
      get(url)
    end
  end
end
