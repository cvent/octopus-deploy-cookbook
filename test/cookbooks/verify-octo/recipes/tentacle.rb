#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: verify-octo
# Recipe:: tentacle
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

tentacle = node['verify-octo']['tentacle']

# Just make sure its not installed already
octopus_deploy_tentacle 'Tentacle' do
  action :remove
  version tentacle['version']
end

# Install it here
octopus_deploy_tentacle 'Tentacle' do
  action :install
  version tentacle['version']
  checksum tentacle['checksum']
end

# This section will mock out the certificate creation
cert_file = 'C:\tentacle_cert.txt'
cookbook_file cert_file do
  action :create
  source 'cert.txt'
end

instance = tentacle['instance']
config_path = tentacle['config_path']

powershell_script "mock-configure-tentacle-#{instance}" do
  cwd 'C:\Program Files\Octopus Deploy\Tentacle'
  code <<-EOH
    .\\Tentacle.exe create-instance --instance="#{instance}" --config="#{config_path}" --console
    .\\Tentacle.exe import-certificate --instance="#{instance}" -f #{cert_file} --console
    if ( ! $? ) { throw "ERROR" }
  EOH
  not_if { ::File.exist?(config_path) }
end

octopus_deploy_tentacle 'Tentacle' do
  action :configure
  version node['verify-octo']['tentacle']['version']
  checksum node['verify-octo']['tentacle']['checksum']
  trusted_cert '324JKSJKLSJ324DSFDF3423FDSF8783FDSFSDFS0'
end

include_recipe 'verify-octo::audit_tentacle'
