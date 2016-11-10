#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Resource:: tentacle
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

actions :install, :configure, :register, :remove, :uninstall
default_action :install

attribute :instance, kind_of: String, default: 'Tentacle'
attribute :version, kind_of: String
attribute :checksum, kind_of: String
attribute :home_path, kind_of: String, default: 'C:\Octopus'
attribute :config_path, kind_of: String, default: 'C:\Octopus\Tentacle.config'
attribute :app_path, kind_of: String, default: 'C:\Octopus\Applications'
attribute :trusted_cert, kind_of: String
attribute :polling, kind_of: [TrueClass, FalseClass], default: false
attribute :configure_firewall, kind_of: [TrueClass, FalseClass], default: false
attribute :port, kind_of: [Fixnum, NilClass], default: nil
attribute :cert_file, kind_of: String, default: 'C:\Octopus\tentacle_cert.txt'
attribute :upgrades_enabled, kind_of: [TrueClass, FalseClass], default: true
attribute :server, kind_of: String
attribute :api_key, kind_of: String
attribute :roles, kind_of: Array
attribute :environment, kind_of: [String, Array], default: node.chef_environment
attribute :tenants, kind_of: Array, default: nil
attribute :tenant_tags, kind_of: Array, default: nil
attribute :tentacle_name, kind_of: String, default: node.name
attribute :service_user, kind_of: String, default: nil
attribute :service_password, kind_of: String, default: nil
attribute :public_dns, kind_of: String, default: node['fqdn']
