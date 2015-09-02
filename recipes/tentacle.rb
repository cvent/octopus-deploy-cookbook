#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
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

tentacle_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-tentacle.msi')
installer = node['octopus']['tentacle']['installer']

remote_file tentacle_installer do
  source installer['url']
  checksum installer['checksum']
end

windows_package installer['display_name'] do
  source tentacle_installer
  version installer['version'] if installer['version']
  checksum installer['checksum']
  installer_type :msi
  action :install
  options '/passive /norestart'
end

