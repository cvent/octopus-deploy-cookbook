# frozen_string_literal: true
#
# Author:: Jamie Hopper (<jamiehopper341@gmail.com>)
# Cookbook:: octopus-deploy-test
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

tentacle = node['octopus-deploy-test']['tentacle']

# This section will mock out the certificate creation
cert_directory = 'C:\Octopus Certificate'
cert_file = File.join(cert_directory, 'tentacle_cert.txt')

directory cert_directory

cookbook_file cert_file do
  action :create
  source 'cert.txt'
end

# Just make sure its not installed already
octopus_deploy_tentacle 'Uninstaller' do
  action :uninstall
  version tentacle['version']
end

# The configure action should also install the tentacle
octopus_deploy_tentacle 'Worker' do
  action [:remove, :configure]
  version tentacle['version']
  checksum tentacle['checksum']
  trusted_cert '324JKSJKLSJ324DSFDF3423FDSF8783FDSFSDFS0'
  cert_file cert_file
end

# Create a user to run the tentacle as (the cookbook assumes the user is already present)
service_user = 'octopus_user'
service_password = '5up3rR@nd0m'

user service_user do
  action :create
  password service_password
end

octopus_deploy_tentacle 'register TentacleWithUser' do
  action [:remove, :configure]
  instance 'TentacleWithUser'
  install_url tentacle['installer_url']
  checksum tentacle['checksum']
  polling true
  trusted_cert '324JKSJKLSJ324DSFDF3423FDSF8783FDSFSDFS0'
  service_user ".\\#{service_user}"
  service_password service_password
  home_path 'C:\OctopusWithUser'
  config_path 'C:\OctopusWithUser\Tentacle.config'
  app_path 'C:\OctopusWithUser\Applications'
  cert_file cert_file
  tenated_deployment_participation :Untenanted
end
