#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy-test
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
directory 'C:\Octopus' do
  action :create
end

cookbook_file 'C:\Octopus\tentacle_cert.txt' do
  action :create
  source 'cert.txt'
end

# Just make sure its not installed already
octopus_deploy_tentacle 'Tentacle' do
  action :uninstall
  version tentacle['version']
end

# Install it here
octopus_deploy_tentacle 'Tentacle' do
  action :install
  version tentacle['version']
  checksum tentacle['checksum']
end

octopus_deploy_tentacle 'Tentacle' do
  action :configure
  version tentacle['version']
  checksum tentacle['checksum']
  trusted_cert '324JKSJKLSJ324DSFDF3423FDSF8783FDSFSDFS0'
end

# Install the Tentacle With User

tentacle_with_user_dir = 'C:\Octopus2'

directory tentacle_with_user_dir do
  action :create
end

tentacle_with_user_certfile = File.join(tentacle_with_user_dir, 'tentacle_cert.txt')
cookbook_file tentacle_with_user_certfile do
  action :create
  source 'cert.txt'
end

user node['octopus_deploy_test']['username'] do
  password '5up3rR@nd0m'
end

# Install it here
octopus_deploy_tentacle 'install TentacleWithUser' do
  action :install
  instance 'TentacleWithUser'
  version tentacle['version']
  checksum tentacle['checksum']
end

octopus_deploy_tentacle 'configure TentacleWithUser' do
  action :configure
  instance 'TentacleWithUser'
  version tentacle['version']
  checksum tentacle['checksum']
  trusted_cert '324JKSJKLSJ324DSFDF3423FDSF8783FDSFSDFS0'
  service_user ".\\#{node['octopus_deploy_test']['username']}"
  service_password '5up3rR@nd0m'
  
  home_path tentacle_with_user_dir
  config_path File.join(tentacle_with_user_dir, 'Tentacle.config')
  app_path File.join(tentacle_with_user_dir, 'Applications')
  cert_file tentacle_with_user_certfile
end
