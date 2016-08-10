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
  end

  describe 'api_client' do
    it 'should return an instance of the chef api client' do
      expect(shared).to respond_to :api_client
    end
  end

  describe 'catch_powershell_error' do
    it 'should return a error statement with the specified error text' do
      expect(shared.catch_powershell_error('HELLO_WORLD')).to match(/throw "ERROR: .* HELLO_WORLD.*/)
    end
  end
end
