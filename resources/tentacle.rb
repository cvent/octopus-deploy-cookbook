# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Resource:: tentacle
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

include OctopusDeploy::Tentacle

resource_name 'octopus_deploy_tentacle'

property :instance, String, default: 'Tentacle'
property :version, String
property :checksum, String
property :home_path, String, default: 'C:\Octopus'
property :config_path, String, default: 'C:\Octopus\Tentacle.config'
property :app_path, String, default: 'C:\Octopus\Applications'
property :trusted_cert, String
property :polling, [true, false], default: false
property :configure_firewall, [true, false], default: false
property :port, [Integer, nil], default: nil
property :cert_file, String, default: 'C:\Octopus\tentacle_cert.txt'
property :upgrades_enabled, [true, false], default: true
property :server, String
property :api_key, String
property :roles, Array
property :environment, [String, Array], default: node.chef_environment
property :tenants, [Array, nil], default: nil
property :tenant_tags, [Array, nil], default: nil
property :tentacle_name, String, default: node.name
property :service_user, [String, nil], default: nil
property :service_password, [String, nil], default: nil
property :public_dns, String, default: node['fqdn']

default_action :install

action :install do
  verify_version(version)
  verify_checksum(checksum)

  tentacle_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-tentacle.msi')
  install_url = installer_url(new_resource.version)

  remote_file tentacle_installer do
    action :create
    source install_url
    checksum new_resource.checksum if new_resource.checksum
  end

  windows_package display_name do
    action :install
    source tentacle_installer
    version new_resource.version if new_resource.version && upgrades_enabled
    installer_type :msi
    options installer_options
  end
end

action :configure do
  action_install

  port = resolve_port(polling, new_resource.port)
  service_name = service_name(instance)

  directory home_path do
    action :create
    recursive true
  end

  powershell_script "generate-tentacle-cert-#{instance}" do
    action :run
    cwd tentacle_install_location
    code <<-EOH
      .\\Tentacle.exe new-certificate -e "#{cert_file}" --console
      #{catch_powershell_error('Generating Cert for the machine')}
    EOH
    not_if { cert_file.nil? || ::File.exist?(cert_file) }
  end

  powershell_script "create-instance-#{instance}" do
    action :run
    cwd tentacle_install_location
    code <<-EOH
      .\\Tentacle.exe create-instance --instance="#{instance}" --config="#{config_path}" --console
      #{catch_powershell_error('Creating instance')}
    EOH
    not_if { ::File.exist?(config_path) }
  end

  powershell_script "configure-tentacle-#{instance}" do # ~FC009
    action :run
    cwd tentacle_install_location
    sensitive new_resource.sensitive
    code <<-EOH
      .\\Tentacle.exe import-certificate --instance="#{instance}" -f #{cert_file} --console
      #{catch_powershell_error('Importing Certificate that was generated for the machine')}
      .\\Tentacle.exe new-certificate --instance="#{instance}" --if-blank --console
      #{catch_powershell_error('Generating Certificate if the Import failed')}
      .\\Tentacle.exe configure --instance="#{instance}" --reset-trust --console
      #{catch_powershell_error('Reseting Trust')}
      .\\Tentacle.exe configure --instance="#{instance}" --home="#{home_path}" --app="#{app_path}" --port="#{port}" --noListen="#{powershell_boolean(polling)}" --console
      #{catch_powershell_error('Configuring instance')}
      .\\Tentacle.exe configure --instance="#{instance}" --trust="#{trusted_cert}" --console
      #{catch_powershell_error('Trusting Octopus Deploy Server')}
      .\\Tentacle.exe service --instance="#{instance}" --install --console
      #{catch_powershell_error('Installing Service')}
    EOH
    not_if { ::Win32::Service.exists?(service_name) }
  end

  windows_firewall_rule 'Octopus Deploy Tentacle' do
    action :create
    localport port.to_s
    dir :in
    protocol 'TCP'
    firewall_action :allow
    only_if { configure_firewall }
    not_if { polling }
  end

  # Make sure enabled and started
  windows_service service_name do
    action [:enable, :start]
    run_as_user service_user
    run_as_password service_password
    sensitive new_resource.sensitive
  end
end

action :register do
  port = resolve_port(polling, new_resource.port)
  environment = Array(new_resource.environment)
  service_name = service_name(instance)

  verify_server(server)
  verify_api_key(api_key)
  verify_roles(roles)
  verify_environment(environment)

  powershell_script "register-#{instance}-tentacle" do
    action :run
    cwd tentacle_install_location
    code <<-EOH
      .\\Tentacle.exe register-with --instance "#{instance}" --server "#{server}" --name "#{tentacle_name}" --publicHostName "#{public_dns}" --apiKey "#{api_key}" #{register_comm_config(polling, port)} #{option_list('environment', environment)} #{option_list('role', roles)} #{option_list('tenant', tenants)} #{option_list('tenanttag', tenant_tags)} --console
      #{catch_powershell_error('Registering Tentacle')}
    EOH
    # This is sort of a hack, you need to specify the config_path on register if it is not default
    # The other option is to read the registry key but the helpers are not available in 12.4.1
    not_if { tentacle_exists?(server, api_key, tentacle_thumbprint(config_path)) }
    notifies :restart, "windows_service[#{service_name}]", :delayed
  end

  windows_service service_name do
    action :nothing
  end
end

action :remove do
  service_name = service_name(instance)

  powershell_script "remove-tentacle-instance-#{instance}" do
    action :run
    cwd tentacle_install_location
    code <<-EOH
      .\\Tentacle.exe service --instance "#{instance}" --stop --uninstall --console
      #{catch_powershell_error('Uninstalling tentacle service')}
      .\\Tentacle.exe delete-instance --instance "#{instance}" --console
      #{catch_powershell_error('Deleting instance from the server')}
    EOH
    only_if { ::Win32::Service.exists?(service_name) && ::File.exist?(tentacle_install_location) }
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

  file ::File.join(Chef::Config[:file_cache_path], 'octopus-tentacle.msi') do
    action :delete
  end
end

def verify_version(version)
  raise 'A version is required in order to install Octopus Deploy Tentacle' unless version
end

def verify_checksum(checksum)
  Chef::Log.warn 'You should include a checksum in the octopus_deploy_tentacle resource for security and performance reasons' unless checksum
end

def verify_server(server)
  raise 'A server is required in order to register a Tentacle with Octopus Deploy Server' unless server
end

def verify_api_key(api_key)
  raise 'An API key is required in order to register a Tentacle with Octopus Deploy Server' unless api_key
end

def verify_roles(roles)
  raise 'At least 1 role is required in order to register a Tentacle with Octopus Deploy Server' if roles.nil? || roles.empty?
end

def verify_environment(environment)
  raise 'At least 1 environment is required in order to register a Tentacle with Octopus Deploy Server' if environment.nil? || environment.empty?
end
