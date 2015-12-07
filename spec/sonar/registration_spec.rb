# encoding: utf-8
require 'spec_helper'

describe Sonar::Registration do
  let(:client) { Sonar::Client.new }

  context 'POSTing a valid product key' do
    let (:resp) do
      VCR.use_cassette("valid_ms_registration") do
        client.register_metasploit("SOME-VALID-KEY")
      end
    end

    it 'responds that the license is valid' do
      expect(resp).to have_key('valid')
      expect(resp['valid']).to be(true)
    end
    it 'responds with a user email' do
      expect(resp).to have_key('email')
      expect(resp['email']).to eq('metasploit-sdafsaefaef@rapid7.com')
    end
    it 'responds with an api_key' do
      expect(resp).to have_key('api_key')
      expect(resp['api_key']).to match('YOUR-VALID-API-KEY')
    end
  end

  context 'POSTing an invalid product key' do
    let (:resp) { client.register_metasploit("DDXXXX") }

    it 'responds that the license is invalid' do
      expect(resp).to have_key('valid')
      expect(resp['valid']).to be(false)
    end
    it 'responds with an error message' do
      expect(resp).to have_key('error')
      expect(resp['error']).to match(/not appear to be valid/)
    end
  end
end
