#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Provider:: tools
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

include OctopusDeploy::Shared

use_inline_resources

action :install do
  new_resource = @new_resource
  checksum = new_resource.checksum
  tools_source = new_resource.source
  path = new_resource.path

  tools_zip = ::File.join(Chef::Config[:file_cache_path], 'OctopusTools.zip')

  download = remote_file tools_zip do
    action :create
    source tools_source
    checksum checksum if checksum
  end

  directory = directory path do
    action :create
    recursive true
  end

  unzip = windows_zipfile path do
    action :unzip
    source tools_zip
    not_if { ::File.exist?(::File.join(path, 'Octo.exe')) }
  end

  new_resource.updated_by_last_action(actions_updated?([download, directory, unzip]))
end
