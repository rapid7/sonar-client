# encoding: utf-8
require 'spec_helper'

describe Sonar::Registration do
  let(:client) { Sonar::Client.new }

  context 'POSTing a valid product key' do
    let (:resp) { client.register_metasploit("1e80c24b97c928bb1db7d4d3c05475a6a40a1186") }

    xit 'responds that the license is valid' do
      expect(resp).to have_key('valid')
      expect(resp['valid']).to be(true)
    end
    xit 'responds with a user email' do
      expect(resp).to have_key('email')
      expect(resp['email']).to match(/@/)
    end
    xit 'responds with an api_key' do
      expect(resp).to have_key('api_key')
      expect(resp['api_key']).to match(/KEY/)
    end
  end

  context 'POSTing an invalid product key' do
    let (:resp) { client.register_metasploit("DDXXXX") }

    xit 'responds that the license is invalid' do
      expect(resp).to have_key('valid')
      expect(resp['valid']).to be(false)
    end
  end
end
