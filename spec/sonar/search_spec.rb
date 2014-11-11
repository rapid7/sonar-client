# encoding: utf-8
require 'spec_helper'

describe Sonar::Search do

  let(:client) { Sonar::Client.new }

  describe "rdns" do
    context "rdnsname" do
      let(:resp) { client.get_rdns(q: '208.118.227.10.rapid7.com') }

      it "returns hashie response of search" do
        expect(resp.class).to eq(Hashie::Mash)
      end

      it "rdnsname finds 208.118.227.10 for 208.118.227.10.rapid7.com" do
        expect(resp['collection'].any?{|x| x['address'] == '208.118.227.10'}).to be(true)
      end
    end

    context "rdnsip" do
      let(:resp) { client.get_rdns(q: '188.40.56.11') }

      it "rdnsip finds static.11.56.40.188.clients.your-server.de for 188.40.56.11" do
        expect(resp['collection'].any?{|x| x['name'] == 'static.11.56.40.188.clients.your-server.de'}).to be(true)
      end
    end

    context "validation" do
      let(:resp) { client.get_rdns(q: '188.40.56.11@#&#') }

      it "should error for invalid domain query type" do
        expect(resp["error"]).to eq("Invalid query")
        expect(resp["errors"].first).to eq("Expected a domain but got '188.40.56.11@#&#'")
      end
    end
  end

  describe "fdns" do
    context "fdnsname" do
      let(:resp) { client.get_fdns(q: 'rapid7.com') }

      it "returns hashie response of search" do
        expect(resp.class).to eq(Hashie::Mash)
      end

      it "finds fdnsname 208.118.227.10 for rapid7.com" do
        expect(resp['collection'].any?{|x| x['address'] == '208.118.227.10'}).to be(true)
      end
    end

    context "fdnsip" do
      let(:resp) { client.get_fdns(q: '208.118.227.10') }

      it "finds fdnsip rapid7.com at 208.118.227.10" do
        expect(resp['collection'].any?{|x| x['address'] == 'rapid7.com'}).to be(true)
      end
    end

    context "validation" do
      let(:resp) { client.get_fdns(q: '188.40.56.11@#&#') }

      it "should error for invalid domain query type" do
        expect(resp["error"]).to eq("Invalid query")
        expect(resp["errors"].first).to eq("Expected a domain but got '188.40.56.11@#&#'")
      end
    end
  end
end
