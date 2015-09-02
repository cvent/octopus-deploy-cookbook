#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Attribute:: default
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

# Server install information
default['octopus']['server']['installer']['display_name'] = 'Octopus Deploy Server'
default['octopus']['server']['installer']['url'] = 'https://download.octopusdeploy.com/octopus/Octopus.2.6.4.951-x64.msi'
default['octopus']['server']['installer']['checksum'] = '496d5ccbc0f711e7bb83bb5952a519c548b4c3121a56578ce2519ff29bcc0e86'
default['octopus']['server']['installer']['version'] = '2.6.4.951'

# Server instance configuration
default['octopus']['server']['instance']['name'] = 'OctopusServer'
default['octopus']['server']['instance']['service_name'] = 'OctopusDeploy'
default['octopus']['server']['instance']['home_path'] = 'C:\Octopus'
default['octopus']['server']['instance']['config_file'] = 'C:\\Octopus\\OctopusServer\\OctopusServer.config'
default['octopus']['server']['instance']['admin'] = nil
default['octopus']['server']['instance']['license'] = nil
default['octopus']['server']['instance']['check_upgrades'] = 'True' # should be True or False
default['octopus']['server']['instance']['report_stats'] = 'True' # Should be Trie or False
default['octopus']['server']['instance']['auth_method'] = 'Domain'

# Tentacle install properties
default['octopus']['tentacle']['installer']['display_name'] = 'Octopus Deploy Tentacle'
default['octopus']['tentacle']['installer']['url'] = 'https://download.octopusdeploy.com/octopus/Octopus.Tentacle.2.6.4.951-x64.msi'
default['octopus']['tentacle']['installer']['checksum'] = '4ba596732593aea82a1912552580da9290b1479f33f6f869446e7870724531c2'
default['octopus']['tentacle']['installer']['version'] = '2.6.4.951'

# Tentacle instance configuration
default['octopus']['tentacle']['instance']['name'] = 'Tentacle'
default['octopus']['tentacle']['instance']['service_name'] = 'OctopusDeploy Tentacle'
default['octopus']['tentacle']['instance']['home_path'] = 'C:\Octopus'
default['octopus']['tentacle']['instance']['config_file'] = 'C:\Octopus\Tentacle\Tentacle.config'
default['octopus']['tentacle']['instance']['app_path'] = 'C:\WebApps'
default['octopus']['tentacle']['instance']['trusted_cert'] = ''
default['octopus']['tentacle']['instance']['listen_port'] = '10933'
default['octopus']['tentacle']['instance']['polling'] = 'False'

