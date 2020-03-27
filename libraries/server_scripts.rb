# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook:: octopus-deploy
# Library:: ServerScripts
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

require_relative 'template_scripts'

# Scripts to install the server wrapped in an ERB
class ServerScripts < TemplateScripts
  def create_instance(resource)
    generate_script(create, binding)
  end

  def configure_instance(resource)
    generate_script(configure, binding)
  end

  def delete_instance(resource)
    generate_script(delete, binding)
  end

  private

  def create
    @create || <<-SCRIPT
      .\\Octopus.Server.exe create-instance `
        <%= option('instance', resource.instance) %> `
        <%= option('config', resource.config_path) %> `
        --console
      <%= catch_powershell_error('Creating instance') %>
      SCRIPT
  end

  def delete
    @delete || <<-SCRIPT
      .\\Octopus.Server.exe service `
        <%= option('instance', resource.instance) %> `
        --stop `
        --uninstall `
        --console
      <%= catch_powershell_error('Uninstalling Octopus Server Service') %>

      .\\Octopus.Server.exe delete-instance `
        <%= option('instance', resource.instance) %> `
        --console
      <%= catch_powershell_error('Deleting instance from the node') %>
      SCRIPT
  end

  def configure
    @configure || <<-SCRIPT
      .\\Octopus.Server.exe configure `
        <%= option('instance', resource.instance) %> `
        <%= option('home', resource.home_path) %> `
        --console
      <%= catch_powershell_error('Configuring Home Dir') %>

      .\\Octopus.Server.exe database `
        <%= option('instance', resource.instance) %> `
        <%= option('connectionString', resource.connection_string) %> `
        --console
      <%= catch_powershell_error('Configuring Database Connection') %>

      .\\Octopus.Server.exe configure `
        <%= option('instance', resource.instance) %> `
        --upgradeCheck "True" `
        --upgradeCheckWithStatistics "True" `
        --console
      <%= catch_powershell_error('Configuring Upgrade Checks') %>

      .\\Octopus.Server.exe configure `
        <%= option('instance', resource.instance) %> `
        --webAuthenticationMode "Domain" `
        --console
      <%= catch_powershell_error('Configuring authentication') %>

      .\\Octopus.Server.exe configure `
        <%= option('instance', resource.instance) %> `
        <%= option('serverNodeName', resource.node_name) %> `
        --console
      <%= catch_powershell_error('Configuring Cluster Node Name') %>

      .\\Octopus.Server.exe configure `
        <%= option('instance', resource.instance) %> `
        --webForceSSL "False" `
        --webListenPrefixes "http://localhost:80/" `
        --commsListenPort "10943" `
        --console
      <%= catch_powershell_error('Configuring Listen Ports') %>

      <% if resource.master_key %>
        .\\Octopus.Server.exe configure `
          <%= option('instance', resource.instance) %> `
          <%= option('masterkey', resource.master_key) %> `
          --console
        <%= catch_powershell_error('Configuring Master Key') %>
      <% end %>

      <% if resource.create_database %>
        .\\Octopus.Server.exe database `
          <%= option('instance', resource.instance) %> `
          --create `
          --console
        <%= catch_powershell_error('Create Database') %>
      <% end %>

      .\\Octopus.Server.exe service `
        <%= option('instance', resource.instance) %> `
        --stop `
        --console
      <%= catch_powershell_error('Stop Service') %>

      <% if resource.admin_user %>
        .\\Octopus.Server.exe admin `
          <%= option('instance', resource.instance) %> `
          <%= option('username', resource.admin_user) %> `
          --console
        <%= catch_powershell_error('Set Administrator') %>
      <% end %>

      <% if resource.license %>
        .\\Octopus.Server.exe license `
          <%= option('instance', resource.instance) %> `
          <%= option('licenseBase64', Base64.encode64(resource.license)) %> `
          --console
        <%= catch_powershell_error('Configuraing License') %>
      <% end %>

      .\\Octopus.Server.exe service `
        <%= option('instance', resource.instance) %> `
        --install `
        --reconfigure `
        --console
      <%= catch_powershell_error('Create Service') %>
      SCRIPT
  end
end
