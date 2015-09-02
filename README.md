Octopus Deploy Cookbook
================

This cookbook is used for installing the [Octopus Deploy](http://octopusdeploy.com) server and tentacle on Microsoft Windows machines.


## Usage

```
# Installs tentacle
include_recipe 'windows-octopus::tentacle'

# Installs and configures the tentacle
include_recipe 'windows-octopus::configure_tentacle'

# Installs server
include_recipe 'windows-octopus::server'

# Installs and configures the server
include_recipe 'windows-octopus::configure_server'

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
