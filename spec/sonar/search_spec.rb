# encoding: utf-8
require 'spec_helper'

describe Sonar::Search do

  let(:client) { Sonar::Client.new }

  context "#get_profile" do
    before do
      @search = client.get_search({})
    end

    it "returns JSON response of Sonar::Search", vcr: true do
      pending
      @search.should_not be_nil
    end
  end

end
