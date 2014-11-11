# encoding: utf-8
require 'spec_helper'

describe Sonar do

  let(:client) { Sonar::Client.new }

  context "configure defaults" do

    it "uses default API URL" do
      client.api_url.should eq 'http://localhost:3003'
    end

    it "uses default API VERSION" do
      client.api_version.should eq 'v2'
    end
  end

  context "handles custom configuration for url and version" do
    let(:new_client) { Sonar::Client.new(
      api_url: 'https://sonar.labs.rapid7.com',
      api_version: 'v1'
    )}

    it "::Client API_URL configuration" do
      new_client.api_url.should eq 'https://sonar.labs.rapid7.com'
    end

    it "::Client API_VERSION configuration" do
      new_client.api_version.should eq 'v1'
    end
  end

  context "when making a request to the client with bad creds" do
    before do
      client.email = "wrong@sowrong.com"
      client.access_token = "somewrongkey"
      @resp = client.get_rdns(q: "hp.com")
    end

    it "should return unauthorized" do
      expect(@resp["error"]).to eq("Could not authenticate")
    end
  end

  context "when making a request to the client with default, valid creds" do
    before do
      @resp = client.get_rdns(q: "hp.com")
    end

    it "should return success and look like a collection" do
      expect(@resp.has_key?(["more"])).to_not eq("")
    end
  end
end
