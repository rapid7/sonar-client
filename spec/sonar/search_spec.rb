# encoding: utf-8
require 'spec_helper'

describe Sonar::Search do
  let(:dummy_class) {
    Class.new { extend Sonar::Search }
  }
  let(:client) { Sonar::Client.new }

  describe "#ip_search_type_names" do
    it 'includes ports' do
      expect(dummy_class.ip_search_type_names).to include('ports')
    end
    it 'does not include fdns' do
      expect(dummy_class.ip_search_type_names).to_not include('fdns')
    end
  end

  describe "#domain_search_type_names" do
    it 'includes fdns' do
      expect(dummy_class.domain_search_type_names).to include('fdns')
    end
    it 'does not include rdns' do
      expect(dummy_class.domain_search_type_names).to_not include('rdns')
    end
  end

  describe "parameters" do
    describe "query type" do
      context "with an invalid query type" do
        it "should raise an ArgumentError" do
          expect { client.search(invalid: 'something.org') }.to raise_error(ArgumentError)
        end
      end
    end

    describe "limit" do
      # The default size from APIv1/v2 is 25 records
      context "specifying the :limit to 3000 on #search" do
        let(:resp) { client.search(fdns: '.hp.com', limit: 3000) }

        it "should return a RequestIterator" do
          expect(resp.class).to eq(Sonar::Request::RequestIterator)
        end
        it "should return 120 x 25-record blocks" do
          num_blocks = 0
          resp.each do |resp_block|
            if resp_block
              expect(resp_block['collection'].size).to eq(25)
              num_blocks += 1
            end
          end
          expect(num_blocks).to eq(120)
        end
      end
    end
  end

  describe "fdns" do
    context "fdnsname" do
      let(:resp) { client.search(fdns: 'rapid7.com') }

      it "returns hashie response of search" do
        expect(resp.class).to eq(Hashie::Mash::Rash)
      end
      it "finds fdnsname multiple IP addresses for rapid7.com" do
        expect(resp['collection'].select { |x| x['address'] }.size).to be >= 2
      end
    end

    context "fdnsip" do
      let(:resp) { client.search(fdns: '208.118.227.10') }

      it "finds fdnsip rapid7 domains at 208.118.227.10" do
        expect(resp['collection'].any? { |x| x['address'].match('rapidseven') }).to be(true)
      end
    end

    context "validation" do
      let(:resp) { client.search(fdns: '188.40.56.11@#&#') }

      it "should error for invalid domain query type" do
        expect(resp["error"]).to eq("Invalid query")
        expect(resp["errors"].first).to eq("An unsupported gTLD or ccTLD was specified for: 188.40.56.11@#&#")
      end
    end
  end

  # TODO: actually check response
  context "ports" do
    let(:resp) { client.search(ports: '208.118.227.10') }

    it "should return a collection" do
      expect(resp).to have_key('collection')
    end
  end
end
