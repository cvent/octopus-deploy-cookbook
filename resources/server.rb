# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
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
property :node_name, String
property :create_database, [true, false], default: false
property :admin_user, String
property :license, String
property :start_service, [true, false], default: true

default_action :install

action :install do
  verify_version(version)
  verify_checksum(checksum)

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

  powershell_script "create-instance-#{instance}" do
    action :run
    cwd server_install_location
    code <<-EOH
      .\\Octopus.Server.exe create-instance --instance "#{instance}" --config "#{config_path}" --console
      #{catch_powershell_error('Creating instance')}
    EOH
    not_if { ::File.exist?(config_path) }
  end

  powershell_script "configure-server-#{instance}" do # ~FC009
    action :run
    cwd server_install_location
    sensitive new_resource.sensitive
    code <<-EOH
    .\\Octopus.Server.exe configure --instance "#{instance}" --home "#{home_path}" --console
    #{catch_powershell_error('Configuring Home Dir')}
    .\\Octopus.Server.exe configure --instance "#{instance}" --storageConnectionString "#{connection_string}" --console
    #{catch_powershell_error('Configuring Database Connection')}
    .\\Octopus.Server.exe configure --instance "#{instance}" --upgradeCheck "True" --upgradeCheckWithStatistics "True" --console
    #{catch_powershell_error('Configuring Upgrade Checks')}
    .\\Octopus.Server.exe configure --instance "#{instance}" --webAuthenticationMode "Domain" --console
    #{catch_powershell_error('Configuring authentication')}
    .\\Octopus.Server.exe configure --instance "#{instance}" --serverNodeName "#{node_name}" --console
    #{catch_powershell_error('Configuring Cluster Node Name')}
    .\\Octopus.Server.exe configure --instance "#{instance}" --webForceSSL "False" --webListenPrefixes "http://localhost:80/" --commsListenPort "10943" --console
    #{catch_powershell_error('Configuring Listen Ports')}
    #{".\\Octopus.Server.exe configure --instance \"#{instance}\" --masterkey \"#{master_key}\" --console; #{catch_powershell_error('Configuring Master Key')}" if master_key}
    #{".\\Octopus.Server.exe database --instance \"#{instance}\" --create --console; #{catch_powershell_error('Create Database')}" if create_database}
    .\\Octopus.Server.exe service --instance "#{instance}" --stop --console
    #{catch_powershell_error('Stop Service')}
    #{".\\Octopus.Server.exe admin --instance \"#{instance}\" --username \"#{admin_user}\" --console; #{catch_powershell_error('Set administrator')}" if admin_user}
    #{".\\Octopus.Server.exe license --instance \"#{instance}\" --licenseBase64 \"#{Base64.encode64(license)}\" --console; #{catch_powershell_error('Configuring License')}" if license}
    .\\Octopus.Server.exe service --instance "#{instance}" --install --reconfigure --console
    #{catch_powershell_error('Create Service')}
    EOH
    not_if { ::Win32::Service.exists?(service_name) }
  end

  # Make sure enabled and started
  windows_service service_name do
    if start_service
      action [:enable, :start]
    else
      action [:stop, :disable]
    end
  end
end

action :remove do
  powershell_script "remove-server-instance-#{instance}" do
    action :run
    cwd server_install_location
    code <<-EOH
      .\\Octopus.Server.exe service --instance "#{instance}" --stop --uninstall --console
      #{catch_powershell_error('Uninstalling Octopus Server service')}
      .\\Octopus.Server.exe delete-instance --instance "#{instance}" --console
      #{catch_powershell_error('Deleting instance from the node')}
    EOH
    only_if { ::Win32::Service.exists?(service_name) && ::File.exist?(server_install_location) }
  end

  file config_path do
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

def verify_checksum(checksum)
  Chef::Log.warn 'You should include a checksum in the octopus_deploy_server resource for security and performance reasons' unless checksum
end
