#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Recipe:: configure_server
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

include_recipe 'windows-octopus::server'

instance = node['octopus']['server']['instance']

powershell_script "Boostrap Server" do
  cwd 'C:\Program Files\Octopus Deploy\Octopus'
  code <<-EOH
  .\\Octopus.Server.exe create-instance --instance "#{instance['name']}" --config "#{instance['config_file']}"
  .\\Octopus.Server.exe configure --instance "#{instance['name']}" --home "#{instance['home_path']}" --storageMode "Embedded" --upgradeCheck "#{instance['check_upgrades']}" --upgradeCheckWithStatistics "#{instance['report_stats']}" --webAuthenticationMode "#{instance['auth_method']}" --webForceSSL "False" --webListenPrefixes "http://localhost:80/" --storageListenPort "10931" --commsListenPort "10943"
  .\\Octopus.Server.exe service --instance "#{instance['name']}" --stop
  .\\Octopus.Server.exe admin --instance "#{instance['name']}" --username "#{instance['admin']}" --wait "5000"
  .\\Octopus.Server.exe license --instance "#{instance['name']}" --licenseBase64 "#{instance['license']}" --wait "5000"
  .\\Octopus.Server.exe service --instance "#{instance['name']}" --install --reconfigure --start
  EOH
  not_if do ::File.exists?(instance['config_file']) && ::Win32::Service.exists?(instance['service_name']) end
end

windows_service instance['service_name'] do
  action [:enable, :start]
end

