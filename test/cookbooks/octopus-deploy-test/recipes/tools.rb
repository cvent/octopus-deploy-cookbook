# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook:: octopus-deploy-test
# Recipe:: tools
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

octopus_deploy_tools 'C:/octopus' do
  action :install
  source 'https://download.octopusdeploy.com/octopus-tools/4.2.3/OctopusTools.4.2.3.zip'
  checksum '668a9d379cdf40e3831cd3482bffe84efb5f5a596057dee7b88e283b9141a7c4'
end
