# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Resource:: tools
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

resource_name 'octopus_deploy_tools'

property :path, kind_of: String, name_attribute: true
property :source, kind_of: String, required: true
property :checksum, kind_of: String

default_action :install

action :install do
  tools_zip = ::File.join(Chef::Config[:file_cache_path], 'OctopusTools.zip')

  remote_file tools_zip do
    action :create
    source new_resource.source
    checksum new_resource.checksum if new_resource.checksum
  end

  directory new_resource.path do
    action :create
    recursive true
  end

  windows_zipfile new_resource.path do
    action :unzip
    source tools_zip
    not_if { ::File.exist?(::File.join(new_resource.path, 'Octo.exe')) }
  end
end
