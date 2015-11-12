Octopus Deploy Cookbook
=======================

[![Cookbook Converge](https://img.shields.io/appveyor/ci/bigbam505/octopus-deploy-cookbook/master.svg?style=flat-square)](https://ci.appveyor.com/project/bigbam505/octopus-deploy-cookbook) [![Build Status](https://img.shields.io/travis/cvent/octopus-deploy-cookbook/master.svg?style=flat-square)](https://travis-ci.org/cvent/octopus-deploy-cookbook) [![Chef cookbook](https://img.shields.io/cookbook/v/octopus-deploy.svg?style=flat-square)](https://supermarket.chef.io/cookbooks/octopus-deploy) [![GitHub license](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square)](https://github.com/cvent/octopus-deploy-cookbook/blob/master/LICENSE)

This cookbook is used for installing the [Octopus Deploy](http://octopusdeploy.com) server and tentacle on Microsoft Windows machines.


## NOTICE: Pre-Release
This is pre release and there will be major changes to this before its final release.  The recipes for installation and configuration will be switched into resources so people can use the library easier. Once this is found stable it will be released as version 1.0.0, until this point lock down to any minor version that you use.


## Resource/Provider
### octopus_deploy_server
#### Actions
- :install: Install a version of Octopus Deploy server
- :remove: Uninstall a version of the Octopus Deploy server if it is installed

#### Attribute Parameters
- :instance: Name attribute. The Octopus Deploy Server instance name (used for configuring the instance not install)
- :version: Required. The version of Octopus Deploy Server to install
- :checksum: The SHA256 checksum of the Octopus Deploy Server msi file to verify download

#### Example
Install version 3.1.1 of Octopus Deploy Server

```ruby
octopus_deploy_server 'OctopusServer' do
  action :install
  version '3.1.1'
  checksum '<SHA256-checksum>'
end

```

### octopus_deploy_tentacle
#### Actions
- :install: Install a version of Octopus Deploy Tentacle
- :remove: Uninstall a version of the Octopus Deploy Tentacle if it is installed

#### Attribute Parameters
- :instance: Name attribute. The Octopus Deploy Tentacle instance name (used for configuring the instance not install)
- :version: Required. The version of Octopus Deploy Tentacle to install
- :checksum: The SHA256 checksum of the Octopus Deploy Tentacle msi file to verify download

#### Example
Install version 3.1.1 of Octopus Deploy Tentacle

```ruby
octopus_deploy_tentacle 'Tentacle' do
  action :install
  version '3.1.1'
  checksum '<SHA256-checksum>'
end

```


## Assumptions

One major assumption of this cookbook is that you already have .net40 installed on your server.  If you do not then you might need to do that before this cookbook. In addition, some of the resources in here require Chef version 12 in order to work.


License and Author
==================

* Author:: Brent Montague (<bmontague@cvent.com>)

Copyright:: 2015, Cvent, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Please refer to the [license](LICENSE.md) file for more license information.
