# encoding: utf-8
require 'spec_helper'

describe Sonar::Client do

  let(:client) { Sonar::Client.new }

  it "creates a Faraday::Connection" do
    client.connection.should be_kind_of Faraday::Connection
  end

end
