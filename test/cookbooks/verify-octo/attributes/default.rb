#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: verify-octo
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
default['verify-octo']['server']['version'] = '3.2.24'
default['verify-octo']['server']['checksum'] = 'fe82d0ebd4d0cc9baa38962d8224578154131856a3c3e63621e4834efa3006d7'

# Tentacle test configuration
default['verify-octo']['tentacle']['version'] = '3.2.24'
default['verify-octo']['tentacle']['checksum'] = '147f84241c912da1c8fceaa6bda6c9baf980a77e55e61537880238feb3b7000a'
default['verify-octo']['tentacle']['instance'] = 'Tentacle'
default['verify-octo']['tentacle']['config_path'] = 'C:\\Octopus\\Tentacle.config'
