#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Recipe:: configure_tentacle
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

include_recipe 'octopus-deploy::tentacle'

instance = node['octopus']['tentacle']['instance']

powershell_script "Boostrap Tentacle" do
  cwd 'C:\Program Files\Octopus Deploy\Tentacle'
  code <<-EOH
  .\\Tentacle.exe create-instance --instance="#{instance['name']}" --config="#{instance['config_file']}" --console
  .\\Tentacle.exe new-certificate --instance="#{instance['name']}" --if-blank --console
  .\\Tentacle.exe new-squid --instance="#{instance['name']}" --console
  .\\Tentacle.exe configure --instance="#{instance['name']}" --reset-trust --console
  .\\Tentacle.exe configure --instance="#{instance['name']}" --home="#{instance['home_path']}" --app="#{instance['app_path']}" --port="#{instance['listen_port']}" --noListen="#{instance['polling']}" --console
  .\\Tentacle.exe configure --instance="#{instance['name']}" --trust="#{instance['trusted_cert']}" --console
  .\\Tentacle.exe service --instance="#{instance['name']}" --install --start --console
  EOH
  not_if { ::File.exists?(instance['config_file']) && ::Win32::Service.exists?(instance['service_name']) }
end

# Make sure enabled and started
windows_service instance['service_name'] do
  action [ :enable, :start ]
end

