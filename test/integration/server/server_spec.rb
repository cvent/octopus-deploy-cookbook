#
# Author:: Brent Montague (<bmontague@cvent.com>)
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

control 'The Octopus Deploy Server should be installed' do
  describe file('C:\\Program Files\\Octopus Deploy\\Octopus\\Octopus.Server.exe') do
    it { should exist }
    it { should be_file }
  end

  # Commenting this out for now because it does not work on appveyer for some reason.
  # describe powershell('Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "Octopus Deploy Server" } | Select-Object DisplayName,DisplayVersion') do
  #   its('exit_status') { should eq 0 }
  #   its('stdout') { should match(/Octopus Deploy Server/) }
  #   its('stdout') { should match(/3\.2\.24/) }
  # end
end

control 'The Octopus Deploy Server should be configured' do
  describe file('C:\\Octopus') do
    it { should exist }
    it { should be_directory }
  end

  describe file('C:\\Octopus\\OctopusServer.config') do
    it { should exist }
    it { should be_file }
  end

  # Commenting this out for now because it does not work on appveyer for some reason.
  # describe powershell('Get-Service "OctopusDeploy" | Where-Object { $_.status -eq "Stopped" }') do
  #   its('exit_status') { should eq 0 }
  #   its('stdout') { should match(/Stopped/) }
  # end
end
