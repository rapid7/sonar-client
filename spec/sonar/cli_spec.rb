# encoding: utf-8
require 'spec_helper'

describe Sonar::CLI do
  context 'with an invalid stock sonar.rc profile' do
    before do
      Sonar::RCFile.instance.path = "#{fixtures_path}/sonar-stock.rc"
    end
    it 'throws an exception because of errors' do
      expect { run_command('search fdns 8.8.8.8') }.to raise_error(Sonar::Search::SearchError)
    end
  end

  context "with a valid profile" do
    before do
      Sonar::RCFile.instance.path = "#{fixtures_path}/sonar.rc"
    end
    it "should return the profile" do
      output =  run_command('profile')
      expect(output).to match(/email@asdfasdfasfd.com/)
    end

    context 'client that returns an rdns resp' do
      before do
        allow_any_instance_of(Sonar::Client).to receive(:search).and_return(
          { 'collection' => [{ 'address' => '192.168.1.1 ' }], 'more' => 'false' }
        )
      end
      it 'strips whitespace from values' do
        output =  run_command('search rdns 8.8.8.8')
        expect(output).to eq('{"collection":[{"address":"192.168.1.1"}],"more":"false"}')
      end
      it 'can return lines format' do
        output =  run_command('search --format lines rdns 8.8.8.8')
        expect(output).to eq('{"address":"192.168.1.1"}')
      end
    end
    context 'client that returns processed reply with nested json' do
      before do
        allow_any_instance_of(Sonar::Client).to receive(:search).and_return(
          Sonar::Client.new.search(processed: '8.8.8.')
        )
      end
      xit 'parses the nested value as a string' do
        output =  run_command('search processed 8.8.8.')
        expect(JSON.parse(output)['collection'].first['value']['ip']).to eq('8.8.8.8')
      end
    end

    describe 'sonar types command' do
      it 'returns all sonar search types' do
        output = run_command('types')
        expect(output).to match(/Open Ports/)
      end
    end

    describe 'search all command' do
      before do
        allow_any_instance_of(Sonar::Client).to receive(:search).and_return(
          Sonar::Client.new.search(fdns: '208.118.227.20', exact: true)
        )
      end
      it 'returns results when searching for an IP' do
        output = run_command('search all 208.118.227.20')
        expect(output).to match(/rapid7\.com/)
      end
      it 'returns results when searching for a domain' do
        output = run_command('search all rapid7.com')
        expect(output).to match(/208\.118\.227\.20/)
      end
    end
  end

  def run_command(args)
    capture(:stdout) { ret = Sonar::CLI.start(args.split) }.strip
  end
end
