# encoding: utf-8
require 'spec_helper'

describe Sonar::User do
  let(:client) { Sonar::Client.new }

  context "with a valid client querying usage" do
    let(:res) { client.usage }

    it "should show usage information for the user" do
      expect(res.user.api_token).to_not be_nil
      expect(res.current_api_hits).to be >= 0
    end
  end
end
