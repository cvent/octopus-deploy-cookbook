# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook:: octopus-deploy-test
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

# Server test configuration
default['octopus-deploy-test']['server']['version'] = '2018.7.2'
default['octopus-deploy-test']['server']['checksum'] = '89645C258354DE1C8038B5AD630E2EB8F3F1ECE096699A17300636BD116C2423'
default['octopus-deploy-test']['server']['master-key'] = 'wJ+qLI8AjSvtdtIt05eW7w=='
default['octopus-deploy-test']['server']['connection-string'] = 'Server=(local)\SQL2016;Database=OctopusDeploy;User ID=sa;Password=Password12!'

# Tentacle test configuration
default['octopus-deploy-test']['tentacle']['version'] = '3.22.0'
default['octopus-deploy-test']['tentacle']['installer_url'] = 'https://download.octopusdeploy.com/octopus/Octopus.Tentacle.3.22.0-x64.msi'
default['octopus-deploy-test']['tentacle']['checksum'] = '197AB79A95ADEE15AB0058BF0FA73D9E8AF2AA6AEF1741BEB39170C3A1D72CAB'
default['octopus-deploy-test']['tentacle']['instance'] = 'Tentacle'
default['octopus-deploy-test']['tentacle']['config_path'] = 'C:\\Octopus\\Tentacle.config'
