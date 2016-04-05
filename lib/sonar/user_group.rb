# encoding: utf-8

module Sonar
  module UserGroup
    class ReservedGroupName < StandardError
      def initialize(name)
        msg = "Name '#{name}' is reserved and cannot be used."
        super(msg)
      end
    end

    CREATE_USERGROUP_ENDPOINT = "/api/user_groups/create"
    RESERVED_NAMES = %w(anyone)

    # Validates user and pass authentication
    # @param name [String] Name of group
    # @param description [String] optional
    # @return [Hashie::Mash] with methods `valid` and `valid?`
    def create_usergroup(name:, description: nil)
      fail ReservedGroupName, name if RESERVED_NAMES.include? name

      options = {}
      options[:name] = name
      options[:description] = description unless description.nil?
      options[:connection_type] = :basic_authenticated
      options[:basic_auth] = {
        user: @email,
        pass: @pass
      }

      post(CREATE_USERGROUP_ENDPOINT, options)
    end
  end
end
