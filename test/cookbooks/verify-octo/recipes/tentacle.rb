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

# Just make sure its not installed already
octopus_deploy_tentacle 'Tentacle' do
  action :remove
  version node['verify-octo']['tentacle']['version']
end

octopus_deploy_tentacle 'Tentacle' do
  action :install
  version node['verify-octo']['tentacle']['version']
  checksum node['verify-octo']['tentacle']['checksum']
end

include_recipe 'verify-octo::audit_tentacle'
