Octopus Deploy Cookbook
=======================

[![Cookbook Converge](https://img.shields.io/appveyor/ci/bigbam505/octopus-deploy-cookbook/master.svg?style=flat-square&label=appveyor)](https://ci.appveyor.com/project/bigbam505/octopus-deploy-cookbook) [![Build Status](https://img.shields.io/travis/cvent/octopus-deploy-cookbook/master.svg?style=flat-square&label=travis)](https://travis-ci.org/cvent/octopus-deploy-cookbook) [![Code Climate](https://img.shields.io/codeclimate/github/cvent/octopus-deploy-cookbook.svg?style=flat-square)](https://codeclimate.com/github/cvent/octopus-deploy-cookbook) [![Chef cookbook](https://img.shields.io/cookbook/v/octopus-deploy.svg?style=flat-square)](https://supermarket.chef.io/cookbooks/octopus-deploy) [![GitHub license](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square)](https://github.com/cvent/octopus-deploy-cookbook/blob/master/LICENSE)

This cookbook is used for installing the [Octopus Deploy](http://octopusdeploy.com) server and tentacle on Microsoft Windows machines.


## NOTICE: Pre-Release
This is pre release and there will be major changes to this before its final release.  The recipes for installation and configuration will be switched into resources so people can use the library easier. Once this is found stable it will be released as version 1.0.0, until this point lock down to any minor version that you use.

## Resource/Provider
### octopus_deploy_server
#### Actions
- :install: Install a version of Octopus Deploy server
- :configure: Install a version of Octopus Deploy server and configure it
- :remove: Uninstall a version of the Octopus Deploy Server if it is installed

#### Attribute Parameters
- :instance: Name attribute. The Octopus Deploy Server instance name (used for configuring the instance not install)
- :version: Required. The version of Octopus Deploy Server to install
- :checksum: The SHA256 checksum of the Octopus Deploy Server msi file to verify download
- :home_path: The Octopus Deploy Server home directory (Defaults to C:\Octopus)
- :config_path: The Octopus Deploy Server config file path (Defaults to C:\Octopus\OctopusServer.config)
- :connection_string: The Octopus Deploy Server connection string to the MSSQL Server instance
- :master_key: The Octopus Deploy Server master key for encryption, leave blank to generate one at creation
- :node_name: The Octopus Deploy Server Node Name, will default to machine hostname
- :create_database: Whether Octopus Deploy Server should create the database with the connection string provided (Defaults to false)
- :admin_user: A default admin in AD for the Octopus Deploy Server to create
- :license: The raw license key for Octopus Deploy Server to use
- :start_service: Whether to start the Octopus Deploy Server service after creation of the instance (Defaults to True)

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
- :install: Install a version of Octopus Deploy Tentacle (Default)
- :configure: Configure an instance of the octopus Deploy tentacle
- :register: Register Tentacle with Octopus Deploy Server
- :remove: Remove an instance of the Octopus Deploy Tentacle
- :uninstall: Uninstall a version of the Octopus Deploy Tentacle if it is installed

#### Attribute Parameters
- :instance: Name attribute. The Octopus Deploy Tentacle instance name (used for configuring the instance not install)
- :version: Required. The version of Octopus Deploy Tentacle to install
- :checksum: The SHA256 checksum of the Octopus Deploy Tentacle msi file to verify download
- :home_path: The Octopus Deploy Instance home directory (Defaults to C:\Octopus)
- :config_path: The Octopus Deploy Instance config file path (Defaults to C:\Octopus\Tentacle.config)
- :app_path: The Octopus Deploy Instance application directory (Defaults to C:\Octopus\Applications)
- :trusted_cert: The Octopus Deploy Instance trusted Server cert
- :port: The Octopus Deploy Instance port to listen on for listening tentacle (Defaults to 10933)
- :configure_firewall: Whether cookbook will open firewall on listen tentacles (Defaults to false)
- :polling: Whether this Octopus Deploy Instance is a polling tentacle (Defaults to False)
- :cert_file: Where to export the Octopus Deploy Instance cert (Defaults to C:\Octopus\tentacle_cert.txt)
- :upgrades_enabled: Whether to upgrade or downgrade the tentacle version if the windows installer version does not match what is provided in the resource. (Defaults to True)
- :server: Url to Octopus Deploy Server (e.g https://octopus.example.com)
- :api_key: Api Key used to register Tentacle to Octopus Server
- :roles: Array of roles to apply to Tentacle when registering with Octopus Deploy Server (e.g ["web-server","app-server"]) 
- :environment: Which environment the Tentacle will become part of when registering with Octopus Deploy Server (Defaults to node.chef_environment )
- :tenants: Optional array of tenants to add to the tentacle. Tenant must already exist on Octopus Deploy Server. Requires Octopus 3.4
- :tenant_tags: Optional array of tenant tags to add to the tentacle. Tags must already exist on Octopus Deploy Server. Requires Octopus 3.4

#### Examples

##### Install version 3.2.24 of Octopus Deploy Tentacle

This will simply install the version of the tentacle that is specified.

```ruby
octopus_deploy_tentacle 'Tentacle' do
  action :install
  version '3.2.24'
  checksum '147f84241c912da1c8fceaa6bda6c9baf980a77e55e61537880238feb3b7000a'
end
```

##### Install version 3.2.24 of Octopus Deploy Tentacle and configure it

This will install the tentacle and then configure the tentacle on the machine to communicate with the Octopus Deploy server.  It can also update firewall rules if enabled.

```ruby
octopus_deploy_tentacle 'Tentacle' do
  action [:install, :configure]
  version '3.2.24'
  checksum '147f84241c912da1c8fceaa6bda6c9baf980a77e55e61537880238feb3b7000a'
  trusted_cert 'b5b7ea6537852fb5b7ea6537852f3428'
  # You can enable this resource to update firewall rules as well
  configure_firewall true
end
```

##### Register Listening Tentacle with the Octopus Deploy Server

This will check if the tentacle is registered on the Octopus Deploy server and if it is not will register the tentacle in the environment with the tags that are specified.

```ruby
# You will first need to generate an api key
# In Octopus Deploy Server GUI click your Name -> Profile -> API keys
octopus_deploy_tentacle 'Tentacle' do
  action :register
  server 'https://octopus.example.com'
  api_key '12345678910'
  roles ['database']
  # You can set polling to true for a polling tentacle setup
  # polling true
end
```


## Assumptions

One major assumption of this cookbook is that you already have .net40 installed on your server.  If you do not then you might need to do that before this cookbook. In addition, some of the resources in here require Chef version 12 in order to work.


## Known Issues
This does not work with Octopus Deploy versions less than 3.2.3 because of a bug in [exporting tentacle certificates](https://github.com/OctopusDeploy/Issues/issues/2143)

Tentacle roles are only used the first time a Tentacle is registered with an Octopus Deploy Server. Updating tentacle roles in cookbook will not update roles on Octopus Deploy Server.

Registering multiple tentacles on the same machine is not supported.

Switching Tentacle modes between 'polling' & 'listening' is not currently supported.


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
