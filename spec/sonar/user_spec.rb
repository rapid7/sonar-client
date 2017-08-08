# encoding: utf-8
require 'spec_helper'

describe Sonar::User do
  subject(:client) { Sonar::Client.new }

  context "with a valid client querying usage" do
    subject(:res) { client.usage }

    it "should show usage information for the user" do
      expect(res.user.api_token).to_not be_nil
      expect(res.current_api_hits).to be >= 0
    end
  end

  describe "#validate_authentication" do
    let(:faraday_conn) { instance_spy Faraday::Connection }
    let(:hash_mash) { object_spy Hashie::Mash.new(valid: valid?) }

    subject(:auth_check) { client.validate_authentication(user, pass) }

    before do
      allow(client).to receive(:basic_authenticated_connection)
                              .with(user, pass)
                              .and_return faraday_conn

      allow(hash_mash).to receive(:valid?)
                          .with(no_args)
                          .and_return valid?

      allow(client).to receive(:generic_request)
                       .with(:post, Sonar::User::AUTH_VALIDATE_ENDPOINT, {}, conn: faraday_conn)
                       .and_return hash_mash
    end

    context "when are a valid user" do
      let(:user) { "admin" }
      let(:pass) { "admin" }
      let(:valid?) { true }

      subject { auth_check.valid? }

      it { is_expected.to eq true }
    end

    context "when are a valid user" do
      let(:user) { "admin" }
      let(:pass) { "admin" }
      let(:valid?) { false }

      subject { auth_check.valid? }

      it { is_expected.to eq false }
    end
  end
end
