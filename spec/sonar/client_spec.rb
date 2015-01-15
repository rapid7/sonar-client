# encoding: utf-8
require 'spec_helper'

describe Sonar::Client do
  let(:client) { Sonar::Client.new }

  it "creates a Faraday::Connection" do
    expect(client.connection).to be_kind_of Faraday::Connection
  end
end
