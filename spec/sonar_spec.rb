# encoding: utf-8
require 'spec_helper'

describe Sonar do

  let(:client) { Sonar::Client.new }

  context "configure defaults" do

    it "uses default API URL" do
      client.api_url.should eq 'https://sonar.labs.rapid7.com/api'
    end

    it "uses default API VERSION" do
      client.api_version.should eq 'v2'
    end

  end

  context "handles custom configuration for url and version" do
    let(:new_client) { Sonar::Client.new(
      api_url: 'https://sonar-staging.labs.rapid7.com/api',
      api_version: 'v2'
    )}

    it "::Client API_URL configuration" do
      new_client.api_url.should eq 'https://sonar-staging.labs.rapid7.com/api'
    end

    it "::Client API_VERSION configuration" do
      new_client.api_version.should eq 'v2'
    end

  end

end
