#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Provider:: tentacle
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
include OctopusDeploy::Tentacle

use_inline_resources

action :install do
  new_resource = @new_resource
  checksum = new_resource.checksum
  version = new_resource.version
  upgrades_enabled = new_resource.upgrades_enabled

  verify_version(version)
  verify_checksum(checksum)

  tentacle_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-tentacle.msi')
  install_url = installer_url(new_resource.version)

  download = remote_file tentacle_installer do
    action :create
    source install_url
    checksum checksum if checksum
  end

  install = windows_package display_name do
    action :install
    source tentacle_installer
    version version if version && upgrades_enabled
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
  upgrades_enabled = new_resource.upgrades_enabled
  home_path = new_resource.home_path
  config_path = new_resource.config_path
  app_path = new_resource.app_path
  trusted_cert = new_resource.trusted_cert
  port = new_resource.port
  polling = fancy_bool(new_resource.polling)
  service_name = service_name(instance)
  cert_file =  new_resource.cert_file

  install = octopus_deploy_tentacle name do
    action :install
    checksum checksum
    version version
    upgrades_enabled upgrades_enabled
  end

  create_home_dir = directory home_path do
    action :create
    recursive true
  end

  generate_cert = powershell_script 'generate-tentacle-cert' do
    action :run
    cwd tentacle_install_location
    code <<-EOH
      .\\Tentacle.exe new-certificate -e "#{cert_file}" --console
      #{catch_powershell_error('Generating Cert for the machine')}
    EOH
    not_if { cert_file.nil? || ::File.exist?(cert_file) }
  end

  create_instance = powershell_script "create-instance-#{instance}" do
    action :run
    cwd tentacle_install_location
    code <<-EOH
      .\\Tentacle.exe create-instance --instance="#{instance}" --config="#{config_path}" --console
      #{catch_powershell_error('Creating instance')}
    EOH
    not_if { ::File.exist?(config_path) }
  end

  configure = powershell_script "configure-tentacle-#{instance}" do
    action :run
    cwd tentacle_install_location
    code <<-EOH
      .\\Tentacle.exe import-certificate --instance="#{instance}" -f #{cert_file} --console
      #{catch_powershell_error('Importing Certificate that was generated for the machine')}
      .\\Tentacle.exe new-certificate --instance="#{instance}" --if-blank --console
      #{catch_powershell_error('Generating Certificate if the Import failed')}
      .\\Tentacle.exe configure --instance="#{instance}" --reset-trust --console
      #{catch_powershell_error('Reseting Trust')}
      .\\Tentacle.exe configure --instance="#{instance}" --home="#{home_path}" --app="#{app_path}" --port="#{port}" --noListen="#{polling}" --console
      #{catch_powershell_error('Configuring instance')}
      .\\Tentacle.exe configure --instance="#{instance}" --trust="#{trusted_cert}" --console
      #{catch_powershell_error('Trusting Octopus Deploy Server')}
      .\\Tentacle.exe service --instance="#{instance}" --install --start --console
      #{catch_powershell_error('Installing / starting service')}
    EOH
    notifies :restart, "windows_service[#{service_name}]", :delayed
    not_if { ::Win32::Service.exists?(service_name) }
  end

  # Make sure enabled and started
  service = windows_service service_name do
    action [:enable, :start]
  end

  new_resource.updated_by_last_action(actions_updated?([install, create_home_dir, generate_cert, create_instance, configure, service]))
end

action :remove do
  new_resource = @new_resource
  config_path = new_resource.config_path
  instance = new_resource.instance
  service_name = service_name(instance)

  remove_instance = powershell_script "remove-tentacle-instance-#{instance}" do
    action :run
    cwd tentacle_install_location
    code <<-EOH
      .\\Tentacle.exe service --instance "#{instance}" --stop --uninstall --console
      #{catch_powershell_error('Uninstalling tentacle service')}
      .\\Tentacle.exe delete-instance --instance "#{instance}" --console
      #{catch_powershell_error('Deleting instance from the server')}
    EOH
    only_if { ::Win32::Service.exists?(service_name) && ::File.exists?(::File.join(tentacle_install_location, "Tentacle.exe")) }
  end

  remove_config_file = file config_path  do
    action :delete
  end

  new_resource.updated_by_last_action(actions_updated?([remove_instance, remove_config_file]))
end

action :uninstall do
  new_resource = @new_resource
  name = new_resource.name
  config_path = new_resource.config_path
  instance = new_resource.instance

  remove_instance = octopus_deploy_tentacle name do
    action :remove
    instance instance
    config_path config_path
  end

  uninstall_package = windows_package display_name do
    action :remove
    source 'nothing'
  end

  tentacle_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-tentacle.msi')
  delete_installer = file tentacle_installer do
    action :delete
  end

  new_resource.updated_by_last_action(actions_updated?([remove_instance, uninstall_package, delete_installer]))
end

private

def verify_version(version)
  raise 'A version is required in order to install Octopus Deploy Tentacle' unless version
end

def verify_checksum(checksum)
  Chef::Log.warn 'You should include a checksum in the octopus_deploy_tentacle resource for security and performance reasons' unless checksum
end
