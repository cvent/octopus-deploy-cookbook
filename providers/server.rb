#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Provider:: server
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

include OctopusDeploy::Shared
include OctopusDeploy::Server

use_inline_resources

action :install do
  new_resource = @new_resource
  checksum = new_resource.checksum
  version = new_resource.version

  verify_version(version)
  verify_checksum(checksum)

  server_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-server.msi')
  install_url = installer_url(new_resource.version)

  download = remote_file server_installer do
    action :create
    source install_url
    checksum checksum if checksum
  end

  install = windows_package display_name do
    action :install
    source server_installer
    version version
    installer_type :msi
    options '/passive /norestart'
  end

  new_resource.updated_by_last_action(download.updated_by_last_action? || install.updated_by_last_action?)
end

action :configure do
  new_resource = @new_resource
  name = new_resource.name
  instance = new_resource.instance
  checksum = new_resource.checksum
  version = new_resource.version
  home_path = new_resource.home_path
  config_path = new_resource.config_path
  connection_string = new_resource.connection_string
  master_key = new_resource.master_key
  node_name = new_resource.node_name
  admin_user = new_resource.admin_user
  license = new_resource.license
  create_database = new_resource.create_database
  start_service = new_resource.start_service

  install = octopus_deploy_server name do
    action :install
    checksum checksum
    version version
  end

  create_instance = powershell_script "create-instance-#{instance}" do
    action :run
    cwd server_install_location
    code <<-EOH
      .\\Octopus.Server.exe create-instance --instance "#{instance}" --config "#{config_path}" --console
      #{catch_powershell_error('Creating instance')}
    EOH
    not_if { ::File.exist?(config_path) }
  end

  configure = powershell_script "configure-server-#{instance}" do # ~FC009
    action :run
    cwd server_install_location
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
    sensitive true
    notifies :restart, "windows_service[#{service_name}]", :delayed if start_service
    not_if { ::Win32::Service.exists?(service_name) }
  end

  # Make sure enabled and started
  service = windows_service service_name do
    if start_service
      action [:enable, :start]
    else
      action [:stop, :disable]
    end
  end

  new_resource.updated_by_last_action(actions_updated?([install, create_instance, configure, service]))
end

action :remove do
  new_resource = @new_resource
  version = new_resource.version

  server_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-server.msi')

  delete = file server_installer do
    action :delete
  end

  remove = windows_package display_name do
    action :remove
    source 'nothing'
    version version if version
  end

  new_resource.updated_by_last_action(remove.updated_by_last_action? || delete.updated_by_last_action?)
end

private

def verify_version(version)
  raise 'A version is required in order to install Octopus Deploy Server' unless version
end

def verify_checksum(checksum)
  Chef::Log.warn 'You should include a checksum in the octopus_deploy_server resource for security and performance reasons' unless checksum
end
