# encoding: utf-8

module Sonar
  module Certificate
    ##
    # Get certificate based on sha1 id
    # /api/v2/certificates/1e80c24b97c928bb1db7d4d3c05475a6a40a1186
    #
    # @return [Hashie::Mash] with response of certificate
    def get_certificate(options = {})
      response = get_endpoint("certificates/#{options[:sha1]}", options)
      response if response
    end
  end
end
