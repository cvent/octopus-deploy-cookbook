# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Library:: shared
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

require 'chef/http'

module OctopusDeploy
  # A container to hold the shared logic instead of attributes
  module Shared
    def powershell_boolean(bool)
      bool.to_s.capitalize
    end

    # Iterate over every option and make a big long string like:
    # --role "web" --role "database" --role "app-server"
    def option_list(name, options)
      options.map { |option| option(name, option) }.join(' ') if name && options
    end

    def option(name, option)
      "--#{name} \"#{option}\"" if name && option
    end

    def installer_options
      '/qn /norestart'
    end

    def api_client(server, api_key)
      options = { headers: { 'X-Octopus-ApiKey' => api_key } }
      Chef::HTTP.new("#{server}/api", options)
    end

    def catch_powershell_error(error_text)
      "if ( ! $? ) { throw \"ERROR: Command returned $LastExitCode #{error_text}\" }"
    end
  end
end
