# encoding: utf-8
require 'spec_helper'

describe Sonar::Client do
  let(:client) { Sonar::Client.new }

  describe "#connection" do
    subject { client.connection }
    it { is_expected.to be_kind_of Faraday::Connection }
  end

  describe "#basic_authenticated_connection" do
    let(:user) { "admin" }
    let(:pass) { "123123" }

    subject { client.basic_authenticated_connection user, pass }
    it { is_expected.to be_kind_of Faraday::Connection }
  end
end
