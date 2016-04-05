# encoding: utf-8

module Sonar
  module User
    AUTH_VALIDATE_ENDPOINT = "/api/authentication/validate"

    def usage
      get_search_endpoint("usage")
    end

    # Validates user and pass authentication
    # @param user [String]
    # @param pass [String]
    # @return [Hashie::Mash] with methods `valid` and `valid?`
    def validate_authentication(user, pass)
      @conn = basic_authenticated_connection(user, pass)
      generic_request(:post, AUTH_VALIDATE_ENDPOINT, {}, conn: @conn)
    end
  end
end
