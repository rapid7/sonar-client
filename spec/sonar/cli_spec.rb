# encoding: utf-8
require 'spec_helper'

describe Sonar::CLI do
  before do
    Sonar::RCFile.instance.path = "#{fixtures_path}/sonar.rc"
  end

  describe "profile" do
    it "should return the profile" do
      output = capture(:stdout) { Sonar::CLI.start(['profile'])}
      expect(output).to match(/email@asdfasdfasfd.com/)
    end
  end
end
