# encoding: utf-8
require 'spec_helper'

# Skip the configure in spec_helper so we can test defaults
describe Sonar, skip_autoconfig: true do
  let(:client) { Sonar::Client.new }
  before :each do
    reset_sonar_config
  end

  context "configure defaults" do
    it "uses default API URL" do
      expect(client.api_url).to eq 'https://sonar.labs.rapid7.com'
    end
    it "uses default API VERSION" do
      expect(client.api_version).to eq 'v2'
    end
  end

  context "handles custom configuration for url and version" do
    let(:new_client) do
      Sonar::Client.new(
        api_url: 'https://somethingnew.com',
        api_version: 'v1'
      )
    end

    it "::Client API_URL configuration" do
      expect(new_client.api_url).to eq 'https://somethingnew.com'
    end
    it "::Client API_VERSION configuration" do
      expect(new_client.api_version).to eq 'v1'
    end
  end

  context "when using a configure block and setting api_version" do
    before do
      Sonar.configure do |c|
        c.api_version = "v3"
      end
    end

    it "should have set the custom api_version" do
      expect(Sonar.api_version).to eq("v3")
    end
    it "should use the default api_url" do
      expect(Sonar.api_url).to eq("https://sonar.labs.rapid7.com")
    end
  end

  context "when making a request to the client with bad creds" do
    before do
      Sonar.configure do |c|
        c.email = "wrong@sowrong.com"
        c.access_token = "somewrongkey"
        c.api_version = "v2"
      end
      puts Sonar.api_url
      client = Sonar::Client.new
      @resp = client.search(fdns: "hp.com")
    end

    it "should return unauthorized" do
      expect(@resp["error"]).to eq("Could not authenticate")
    end
  end
end
