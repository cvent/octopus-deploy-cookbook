# frozen_string_literal: true
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

control 'The Octopus Deploy Tools should be installed' do
  describe file('C:\\octopus') do
    it { should exist }
    it { should be_directory }
  end

  describe file('C:\\octopus\\Octo.exe') do
    it { should exist }
    it { should be_file }
  end
end
