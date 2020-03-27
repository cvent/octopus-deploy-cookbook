# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook:: octopus-deploy-test
# Recipe:: server
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

# We remove and then configure everything everytime
octopus_deploy_server 'OctopusServer' do
  action [:uninstall, :install, :remove, :configure]
  version node['octopus-deploy-test']['server']['version']
  checksum node['octopus-deploy-test']['server']['checksum']
  node_name 'octo-web-01'
  user ENV['machine_user']
  password ENV['machine_password']
  connection_string node['octopus-deploy-test']['server']['connection-string']
  master_key node['octopus-deploy-test']['server']['master-key']
  start_service node['octopus-deploy-test']['server']['start-service']
  create_database node['octopus-deploy-test']['server']['create-database']
end
