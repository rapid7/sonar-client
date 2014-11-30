# encoding: utf-8
require 'spec_helper'

describe Sonar::Search do
  let(:client) { Sonar::Client.new }

  context "sha1 #get_certificate" do
    it "should find the Rapid7 certificate by sha1" do
      res = client.get_certificate(sha1: "1e80c24b97c928bb1db7d4d3c05475a6a40a1186")
      expect(res.subject.CN).to eq("www.rapid7.com")
    end
  end
end
