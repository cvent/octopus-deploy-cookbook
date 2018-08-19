# frozen_string_literal: true
#
# Author:: Brent Montague (<bmontague@cvent.com>)
# Cookbook Name:: octopus-deploy
# Library:: TemplateScripts
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

class TemplateScripts
  include OctopusDeploy::Shared

  def create_instance(_resource)
    raise 'Method not overwritten'
  end

  def configure_instance(_resource)
    raise 'Method not overwritten'
  end

  def delete_instance(_resource)
    raise 'Method not overwritten'
  end

  def generate_script(template, binder)
    ERB.new(template).result(binder)
  end

  def catch_powershell_error(error_text)
    "if ( ! $? ) { throw \"ERROR: Command returned $LastExitCode #{error_text}\" }"
  end
end
