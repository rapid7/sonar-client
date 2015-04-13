# encoding: utf-8
require 'spec_helper'

describe Sonar::CLI do
  context "with a valid profile" do
    before do
      Sonar::RCFile.instance.path = "#{fixtures_path}/sonar.rc"
    end
    it "should return the profile" do
      output = run_command('profile')
      expect(output).to match(/email@asdfasdfasfd.com/)
    end
  end
  context 'a client that returns an rdns resp' do
    before do
      Sonar::RCFile.instance.path = "#{fixtures_path}/sonar.rc"
      allow_any_instance_of(Sonar::Client).to receive(:search).and_return(
        { 'collection' => [{ 'address' => '192.168.1.1 ' }], 'more' => 'false' }
      )
    end
    it 'strips whitespace from values' do
      output = run_command('search rdns 8.8.8.8')
      expect(output).to eq('{"collection":[{"address":"192.168.1.1"}],"more":"false"}')
    end
    it 'can return lines format' do
      output = run_command('search --format lines rdns 8.8.8.8')
      expect(output).to eq('{"address":"192.168.1.1"}')
    end
  end

  def run_command(args)
    capture(:stdout) { Sonar::CLI.start(args.split) }.strip
  end
end
