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

    context 'client that returns an rdns resp' do
      before do
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
    context 'client that returns sslcert reply with nested json' do
      before do
        allow_any_instance_of(Sonar::Client).to receive(:search).and_return(
          Sonar::Client.new.search(sslcert: '152a0a633aaf13f02c428ac1a3e672e895512bfd')
        )
      end
      it 'parses the nested values in an array' do
        output = run_command('search sslcert 152a0a633aaf13f02c428ac1a3e672e895512bfd')
        expect(JSON.parse(output)['collection'].first['details'].first['subject']['ST']).to eq('California')
      end
    end
    context 'client that returns processed reply with nested json' do
      before do
        allow_any_instance_of(Sonar::Client).to receive(:search).and_return(
          Sonar::Client.new.search(processed: '8.8.8.')
        )
      end
      it 'parses the nested value as a string' do
        output = run_command('search processed 8.8.8.')
        expect(JSON.parse(output)['collection'].first['value']['ip']).to eq('8.8.8.8')
      end
    end
  end

  def run_command(args)
    capture(:stdout) { Sonar::CLI.start(args.split) }.strip
  end
end
