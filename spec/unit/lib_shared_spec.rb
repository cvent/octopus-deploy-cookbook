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

  describe 'catch_powershell_error' do
    it 'should return a error statement with the specified error text' do
      expect(shared.catch_powershell_error('HELLO_WORLD')).to match(/throw "ERROR: .* HELLO_WORLD.*/)
    end
  end
end
