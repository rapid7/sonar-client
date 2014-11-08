# encoding: utf-8
require 'spec_helper'

describe Sonar::Search do

  let(:config) {
    {
      api_url: "http://localhost:3003/api/",
      access_token: "8d1fcf6fae9c1e2e70ca8e8241be3a682e47feb4"
    }
  }
  let!(:client) { Sonar::Client.new(config) }

  context "getting a certificate by sha1 #get_certificate" do
    it "should work" do
      res = client.get_certificate(sha1: "1e80c24b97c928bb1db7d4d3c05475a6a40a1186")
    end
  end
end
