# encoding: utf-8

module Sonar
  module User
    def usage
      get_search_endpoint("usage")
    end
  end
end
