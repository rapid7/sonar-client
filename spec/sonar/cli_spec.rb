# encoding: utf-8
require 'spec_helper'

describe Sonar::CLI do
  context "with a valid profile" do
    before do
      Sonar::RCFile.instance.path = "#{fixtures_path}/sonar.rc"
    end
    it "should return the profile" do
      output = capture(:stdout) { Sonar::CLI.start(['profile'])}
      expect(output).to match(/email@asdfasdfasfd.com/)
    end
  end
  context "without a config file" do
    before do
      Sonar::RCFile.instance.path = ""
    end
    xit "should create the missing config file" do
    end
  end
end
