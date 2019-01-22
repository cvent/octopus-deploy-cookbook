# frozen_string_literal: true
require 'spec_helper'
require 'libraries/tentacle'

describe 'OctopusDeploy::Tentacle' do
  let(:tentacle) { Class.new { include OctopusDeploy::Tentacle }.new }

  describe 'display_name' do
    it 'should return the correct display name' do
      expect(tentacle.display_name).to eq 'Octopus Deploy Tentacle'
    end
  end

  describe 'service_name' do
    it 'should return the correct service name for the default instance name' do
      expect(tentacle.service_name('Tentacle')).to eq 'OctopusDeploy Tentacle'
    end

    it 'should return the correct service name for non a default instance name' do
      expect(tentacle.service_name('Instance')).to eq 'OctopusDeploy Tentacle: Instance'
    end
  end

  describe 'tentacle_install_location' do
    it 'should return the install location' do
      expect(tentacle.tentacle_install_location).to eq 'C:\Program Files\Octopus Deploy\Tentacle'
    end
  end

  describe 'tentacle_exists?' do
    it 'should return true if the tentacle exists' do
      stub_request(:get, 'https://octopus.com/api/machines/all?thumbprint=1234')
        .to_return(status: 200, body: '[{"Thumbprint": "1234"}]')

      exists = tentacle.tentacle_exists?('https://octopus.com', 'API-key', '1234')
      expect(exists).to eq true
    end

    it 'should return false if the tentacle doesnt exist' do
      stub_request(:get, 'https://octopus.com/api/machines/all?thumbprint=1234')
        .to_return(status: 200, body: '[]')

      exists = tentacle.tentacle_exists?('https://octopus.com', 'API-key', '1234')
      expect(exists).to eq false
    end
  end

  describe 'tentacle_thumbprint' do
    it 'should return nil if the file does not exist' do
      allow(::File).to receive(:exist?).with('file').and_return(false)

      expect(tentacle.tentacle_thumbprint('file')).to eq nil
    end

    it 'should return the thumbprint if the file exists' do
      allow(::File).to receive(:exist?).with('file').and_return(true)
      allow(::File).to receive(:read).with('file').and_return('<key name="Tentacle.CertificateThumbprint">tEst</key>')

      # This also capitalizes the thumbprint in case it is not.
      expect(tentacle.tentacle_thumbprint('file')).to eq 'TEST'
    end
  end

  describe 'installer_url' do
    it 'should return the correct install url if no installer_url is set' do
      expect(tentacle.installer_url('3.2.1', nil)).to eq 'https://download.octopusdeploy.com/octopus/Octopus.Tentacle.3.2.1-x64.msi'
    end

    it 'should return the specified installer_url if one is provided' do
      expect(tentacle.installer_url('3.2.1', 'https://overridden.com/Octopus.Tentacle.3.2.1-x64.msi')).to eq 'https://overridden.com/Octopus.Tentacle.3.2.1-x64.msi'
    end
  end

  describe 'register_comm_config' do
    it 'should return Tentacle active for polling tentacle' do
      expect(tentacle.register_comm_config(true, 100)).to eq '--comms-style "TentacleActive" --server-comms-port "100" --force'
    end

    it 'should return Tentacle passive' do
      expect(tentacle.register_comm_config(false)).to eq '--comms-style "TentaclePassive"'
    end
  end

  describe 'resolve_port' do
    it 'should return the port that is specified' do
      expect(tentacle.resolve_port(true, 100)).to eq 100
    end

    it 'should return the 10943 for a polling tentacle with no port' do
      expect(tentacle.resolve_port(true)).to eq 10_943
    end

    it 'should return the 10933 for a listening tentacle with no port' do
      expect(tentacle.resolve_port(false)).to eq 10_933
    end
  end

  describe 'proxy_command' do
    it 'should return Polling proxy for polling tentacle' do
      expect(tentacle.proxy_command(true)).to eq 'polling-proxy'
    end

    it 'should return Proxy for non-polling tentacle' do
      expect(tentacle.proxy_command(false)).to eq 'proxy'
    end
  end
end
