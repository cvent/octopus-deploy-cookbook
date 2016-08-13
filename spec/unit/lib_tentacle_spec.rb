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
    it 'should exist' do
      expect(tentacle).to respond_to :tentacle_install_location
    end
  end

  describe 'installer_url' do
    it 'should exist' do
      expect(tentacle).to respond_to :installer_url
    end
  end

  describe 'resolve_port' do
    it 'should return the port that is specified' do
      expect(tentacle.resolve_port(true, 100)).to eq 100
    end

    it 'should return the 10943 for a polling tentacle with no port' do
      expect(tentacle.resolve_port(true, nil)).to eq 10_943
    end

    it 'should return the 10933 for a listening tentacle with no port' do
      expect(tentacle.resolve_port(false, nil)).to eq 10_933
    end
  end
end
