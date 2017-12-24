# frozen_string_literal: true
require 'spec_helper'
require 'libraries/server'

describe 'OctopusDeploy::Server' do
  let(:server) { Class.new { include OctopusDeploy::Server }.new }

  describe 'display_name' do
    it 'should return the correct display name' do
      expect(server.display_name).to eq 'Octopus Deploy Server'
    end
  end

  describe 'service_name' do
    it 'should return the correct service name' do
      expect(server.service_name).to eq 'OctopusDeploy'
    end
  end

  describe 'server_install_location' do
    it 'should return the install location' do
      expect(server.server_install_location).to eq 'C:\Program Files\Octopus Deploy\Octopus'
    end
  end

  describe 'installer_url' do
    it 'should return the install url' do
      expect(server.installer_url('3.2.1')).to eq 'https://download.octopusdeploy.com/octopus/Octopus.3.2.1-x64.msi'
    end
  end

  describe 'scripts' do
    it 'should return the ServerScripts class' do
      expect(server.scripts).to be_a_kind_of(ServerScripts)
    end
  end
end
