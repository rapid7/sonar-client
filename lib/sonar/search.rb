# encoding: utf-8

module Sonar
  module Search

    ##
    # Get rnds search
    #
    # @return [Hashie::Mash] with response of search
    def get_rdns(params={})
      params = extract_params(params)
      get_search_endpoint(:rdns, params)
    end

    ##
    # Get fdns search
    #
    # @return [Hashie::Mash] with response of search
    def get_fdns(params={})
      params = extract_params(params)
      get_search_endpoint(:fdns, params)
    end
  end
end
