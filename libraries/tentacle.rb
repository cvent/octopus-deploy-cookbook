# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Library:: tentacle
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

require_relative 'shared'

module OctopusDeploy
  # A container to hold the tentacle values instead of attributes
  module Tentacle
    include OctopusDeploy::Shared

    def display_name
      'Octopus Deploy Tentacle'
    end

    def service_name(name)
      if name == 'Tentacle'
        'OctopusDeploy Tentacle'
      else
        "OctopusDeploy Tentacle: #{name}"
      end
    end

    def tentacle_install_location
      'C:\Program Files\Octopus Deploy\Tentacle'
    end

    def installer_url(version, url)
      return url if url

      "https://download.octopusdeploy.com/octopus/Octopus.Tentacle.#{version}-x64.msi"
    end

    def tentacle_exists?(server, api_key, thumbprint)
      ::JSON.parse(api_client(server, api_key).get("/machines/all?thumbprint=#{thumbprint}")).any? do |machine|
        machine['Thumbprint'] == thumbprint
      end
    end

    def tentacle_thumbprint(config)
      return unless ::File.exist?(config)

      matcher = ::File.read(config).match(/Tentacle\.CertificateThumbprint">(.*)</)
      return matcher[1].upcase if matcher
    end

    def resolve_port(polling, port = nil)
      port || default_port(polling)
    end

    def register_comm_config(polling, port = nil)
      if polling
        "--comms-style \"TentacleActive\" --server-comms-port \"#{port}\" --force"
      else
        '--comms-style "TentaclePassive"'
      end
    end

    def default_port(polling)
      if polling
        10_943
      else
        10_933
      end
    end
  end
end
