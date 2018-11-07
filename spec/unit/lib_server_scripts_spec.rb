# frozen_string_literal: true
require 'spec_helper'
require 'libraries/server_scripts'

describe 'ServerScripts' do
  let(:server_scripts) { ServerScripts.new }
  let(:resource) do
    Class.new do
      def method_missing(method_name)
        method_name.to_s
      end
    end.new
  end

  describe 'create_instance' do
    it 'should return the script' do
      expect(server_scripts.create_instance(resource)).to match 'create-instance'
    end
  end

  describe 'configure_instance' do
    it 'should return the script' do
      expect(server_scripts.configure_instance(resource)).to match 'configure'
    end
  end

  describe 'delete_instance' do
    it 'should return the script' do
      expect(server_scripts.delete_instance(resource)).to match 'delete-instance'
    end
  end
end
