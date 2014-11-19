# encoding: utf-8
require 'spec_helper'

describe Sonar::Search do

  let(:client) { Sonar::Client.new }

  context "with an invalid query type" do
    it "should raise an ArgumentError" do
      expect{ client.search(invalid: 'something.org') }.to raise_error(ArgumentError)
    end
  end

  # The default size from APIv1 is 1,000 records
  context "specifying the :limit to 3000 on #search" do
    let(:resp) { client.search(rdns: '.hp.com', limit: 3000) }

    it "should return all records" do
      puts resp
      expect(resp['collection'].length).to eq(2000)
    end
  end

  context "certificate" do
    let(:resp) { client.search(certificate: '.hp.com') }

    it "should provide certificate details" do
      expect(resp).to have_key('collection')
    end
  end

  describe "rdns" do
    context "rdnsname" do
      let(:resp) { client.search(rdns: '208.118.227.10.rapid7.com') }

      it "returns hashie response of search" do
        expect(resp.class).to eq(Hashie::Mash)
      end

      it "rdnsname finds 208.118.227.10 for 208.118.227.10.rapid7.com" do
        expect(resp['collection'].any?{|x| x['address'] == '208.118.227.10'}).to be(true)
      end
    end

    context "rdnsip" do
      let(:resp) { client.search(rdns: '188.40.56.11') }

      it "rdnsip finds static.11.56.40.188.clients.your-server.de for 188.40.56.11" do
        expect(resp['collection'].any?{|x| x['name'] == 'static.11.56.40.188.clients.your-server.de'}).to be(true)
      end
    end

    context "validation" do
      let(:resp) { client.search(rdns: '188.40.56.11@#&#') }

      it "should error for invalid domain query type" do
        expect(resp["error"]).to eq("Invalid query")
        expect(resp["errors"].first).to eq("Expected a domain but got '188.40.56.11@#&#'")
      end
    end
  end

  describe "fdns" do
    context "fdnsname" do
      let(:resp) { client.search(fdns: 'rapid7.com') }

      it "returns hashie response of search" do
        expect(resp.class).to eq(Hashie::Mash)
      end

      it "finds fdnsname 208.118.227.10 for rapid7.com" do
        expect(resp['collection'].any?{|x| x['address'] == '208.118.227.10'}).to be(true)
      end
    end

    context "fdnsip" do
      let(:resp) { client.search(fdns: '208.118.227.10') }

      it "finds fdnsip rapid7.com at 208.118.227.10" do
        expect(resp['collection'].any?{|x| x['address'] == 'rapid7.com'}).to be(true)
      end
    end

    context "validation" do
      let(:resp) { client.search(fdns: '188.40.56.11@#&#') }

      it "should error for invalid domain query type" do
        expect(resp["error"]).to eq("Invalid query")
        expect(resp["errors"].first).to eq("Expected a domain but got '188.40.56.11@#&#'")
      end
    end
  end

  context "links_to" do
    let(:resp) { client.search(links_to: 'rapid7.com') }

    it "should provide links_to details" do
      expect(resp).to have_key('collection')
    end
  end

  context "ipcerts" do
    let(:resp) { client.search(ipcerts: '208.118.227.10') }

    it "should provide ipcerts details" do
      expect(resp).to have_key('collection')
    end
  end

  context "certips" do
    let(:resp) { client.search(certips: '1e80c24b97c928bb1db7d4d3c05475a6a40a1186') }

    it "should provide certips details" do
      expect(resp).to have_key('collection')
    end
  end

  context "namecerts" do
    let(:resp) { client.search(namecerts: '.rapid7.com') }

    it "should provide namecerts details" do
      expect(resp).to have_key('collection')
    end
  end

  context "sslcert" do
    let(:resp) { client.search(sslcert: '1e80c24b97c928bb1db7d4d3c05475a6a40a1186') }

    it "should provide sslcert details" do
      expect(resp).to have_key('collection')
    end
  end

  context "whois_ip" do
    let(:resp) { client.search(whois_ip: '208.118.227.10')}

    it "should find rapid7.com" do
      expect(resp['name']).to eq('TWDX-208-118-227-0-1')
    end
  end

  # TODO actually check response
  context "raw" do
    let(:resp) { client.search(raw: '208.118.227.10')}

    it "should return a collection" do
      expect(resp).to have_key('collection')
    end
  end

  # TODO actually check response
  context "processed" do
    let(:resp) { client.search(processed: '208.118.227.10')}

    it "should return a collection" do
      expect(resp).to have_key('collection')
    end
  end

  # TODO actually check response
  context "ports" do
    let(:resp) { client.search(ports: '208.118.227.10')}

    it "should return a collection" do
      expect(resp).to have_key('collection')
    end
  end
end
