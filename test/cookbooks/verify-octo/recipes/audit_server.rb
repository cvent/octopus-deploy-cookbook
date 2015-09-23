#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: verify-octo
# Recipe:: audit_server
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

install_version = "#{node['verify-octo']['server']['version']}.0"

control_group 'verify-octo::server' do
  control 'Octopus Deploy Server' do
    it 'should be installed' do
      expect(package('Octopus Deploy Server')).to be_installed
    end

    it 'should be the correct version' do
      expect(file('C:\Program Files\Octopus Deploy\Octopus\Octopus.Server.exe')).to be_version(install_version)
    end
  end
end
