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
default['verify-octo']['server']['version'] = '3.1.3'
default['verify-octo']['server']['checksum'] = 'c5af09ec60d946a1c6edf564743ffc214f4ff80ff014d35805e18fa3c972da28'

# Tentacle test configuration
default['verify-octo']['tentacle']['version'] = '3.1.3'
default['verify-octo']['tentacle']['checksum'] = 'c5b4cd6ceec977137d93711ca0ede1dde79ae30da277d70e8d70e6d148860bec'
