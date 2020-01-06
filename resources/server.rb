# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook:: octopus-deploy
# Resource:: server
#
# Copyright:: Copyright (c) 2015 Cvent, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include OctopusDeploy::Server

resource_name 'octopus_deploy_server'

property :instance, String, default: 'OctopusServer'
property :version, String, required: true
property :checksum, String
property :home_path, String, default: 'C:\Octopus'
property :config_path, String, default: 'C:\Octopus\OctopusServer.config'
property :connection_string, String
property :master_key, String
property :node_name, String, default: node.name
property :create_database, [true, false], default: false
property :admin_user, String
property :license, String
property :start_service, [true, false], default: true

default_action :install

action :install do
  verify_version(new_resource.version)
  verify_checksum(new_resource.checksum)

  server_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-server.msi')
  install_url = installer_url(new_resource.version)

  remote_file server_installer do
    action :create
    source install_url
    checksum new_resource.checksum if new_resource.checksum
  end

  windows_package display_name do
    action :install
    source server_installer
    version new_resource.version
    installer_type :msi
    options '/passive /norestart'
  end
end

action :configure do
  action_install
  verify_connection_string(new_resource.connection_string)

  powershell_script "create-instance-#{new_resource.instance}" do
    action :run
    cwd server_install_location
    code scripts.create_instance(new_resource)
    not_if { ::File.exist?(new_resource.config_path) }
  end

  powershell_script "configure-server-#{new_resource.instance}" do # ~FC009
    action :run
    cwd server_install_location
    sensitive new_resource.sensitive
    code scripts.configure_instance(new_resource)
    not_if { ::Win32::Service.exists?(service_name) }
  end

  # Make sure enabled and started
  windows_service service_name do
    if new_resource.start_service
      action [:enable, :start]
    else
      action [:stop, :disable]
    end
  end
end

action :remove do
  powershell_script "remove-server-instance-#{new_resource.instance}" do
    action :run
    cwd server_install_location
    code scripts.delete_instance(new_resource)
    only_if { ::Win32::Service.exists?(service_name) && ::File.exist?(server_install_location) }
  end

  file new_resource.config_path do
    action :delete
  end
end

action :uninstall do
  windows_package display_name do
    action :remove
    source 'nothing'
  end

  file ::File.join(Chef::Config[:file_cache_path], 'octopus-server.msi') do
    action :delete
  end
end

def verify_version(version)
  raise 'A version is required in order to install Octopus Deploy Server' unless version
end

def verify_connection_string(connection_string)
  raise 'A connection string is required in order to configure Octopus Deploy Server' unless connection_string
end

def verify_checksum(checksum)
  Chef::Log.warn 'You should include a checksum in the octopus_deploy_server resource for security and performance reasons' unless checksum
end
