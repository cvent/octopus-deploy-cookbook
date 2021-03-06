# frozen_string_literal: true
require 'spec_helper'
require 'libraries/shared'

describe 'OctopusDeploy::Shared' do
  let(:shared) { Class.new { include OctopusDeploy::Shared }.new }

  describe 'powershell_boolean' do
    it 'should return uppercased bools' do
      expect(shared.powershell_boolean(true)).to eq 'True'
      expect(shared.powershell_boolean(false)).to eq 'False'
    end
  end

  describe 'option_list' do
    it 'should return the command line command for an options list' do
      name = 'name'
      options = %w(option1 option2)
      expect(shared.option_list(name, options)).to eq '--name "option1" --name "option2"'
    end

    it 'should return nil if name is nil' do
      name = nil
      options = '42'
      expect(shared.option_list(name, options)).to eq nil
    end

    it 'should return nil if options is nil' do
      name = 'foo'
      options = nil
      expect(shared.option_list(name, options)).to eq nil
    end
  end

  describe 'option_flag' do
    it 'should return --attr flag if name is valid and value is true' do
      name = 'attr'
      value = true
      expect(shared.option_flag(name, value)).to eq '--attr '
    end

    it 'should return empty string if name is valid and value is false' do
      name = 'attr'
      value = false
      expect(shared.option_flag(name, value)).to eq ''
    end

    it 'should return empty string if inputs are invalid' do
      expect(shared.option_flag('', false)).to eq ''
      expect(shared.option_flag('', true)).to eq ''
      expect(shared.option_flag(nil, true)).to eq ''
      expect(shared.option_flag(nil, false)).to eq ''
      expect(shared.option_flag('attr', nil)).to eq ''
    end
  end

  describe 'option' do
    it 'should return the command line command for an option' do
      name = 'name'
      option = :Test
      expect(shared.option(name, option)).to eq '--name "Test"'
    end

    it 'should return nil if name is nil' do
      name = nil
      option = :test
      expect(shared.option(name, option)).to eq nil
    end

    it 'should return nil if option is nil' do
      name = 'name'
      option = nil
      expect(shared.option(name, option)).to eq nil
    end
  end

  describe 'installer_options' do
    it 'should return the command line options for msiexec' do
      expect(shared.installer_options).to eq '/qn /norestart'
    end
  end

  describe 'api_client' do
    it 'should return an instance of the chef api client' do
      client = shared.api_client('https://octopus.com', 'API-blah')
      expect(client).to be_a Chef::HTTP
      expect(client.url).to eq 'https://octopus.com/api'
    end
  end

  describe 'catch_powershell_error' do
    it 'should return a error statement with the specified error text' do
      expect(shared.catch_powershell_error('HELLO_WORLD')).to match(/throw "ERROR: .* HELLO_WORLD.*/)
    end
  end
end
