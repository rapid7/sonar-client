# encoding: utf-8

module Sonar
  module Search

    ##
    # Get search
    #
    # params[:access_token] required parameter
    #
    # @return [Hashie::Mash] with response of search
    def get_search(params={})
      params = extract_params(params)
      get_endpoint(:search, params)
    end
  end
end
