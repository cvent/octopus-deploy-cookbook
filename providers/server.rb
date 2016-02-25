#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Provider:: server
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

include OctopusDeploy::Server

use_inline_resources

action :install do
  new_resource = @new_resource
  checksum = new_resource.checksum
  version = new_resource.version

  verify_version(version)
  verify_checksum(checksum)

  server_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-server.msi')
  install_url = installer_url(new_resource.version)

  download = remote_file server_installer do
    action :create
    source install_url
    checksum checksum if checksum
  end

  install = windows_package display_name do
    action :install
    source server_installer
    version version
    installer_type :msi
    options '/passive /norestart'
  end

  new_resource.updated_by_last_action(download.updated_by_last_action? || install.updated_by_last_action?)
end

action :remove do
  new_resource = @new_resource
  version = new_resource.version

  server_installer = ::File.join(Chef::Config[:file_cache_path], 'octopus-server.msi')

  delete = file server_installer do
    action :delete
  end

  remove = windows_package display_name do
    action :remove
    version version if version
  end

  new_resource.updated_by_last_action(remove.updated_by_last_action? || delete.updated_by_last_action?)
end

private

def verify_version(version)
  raise 'A version is required in order to install Octopus Deploy Server' unless version
end

def verify_checksum(checksum)
  Chef::Log.warn 'You should include a checksum in the octopus_deploy_server resource for security and performance reasons' unless checksum
end
