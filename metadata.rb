name             'octopus-deploy'
maintainer       'Montague, Brent'
maintainer_email 'BMontague@cvent.com'
license          'Apache 2.0'
description      'Handles installing Octopus Deploy Server &| Tentacle'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

supports 'windows'

depends 'windows'

recipe 'octopus-deploy::default', 'This is does nothing'
recipe 'octopus-deploy::tentacle', 'Installs the Octopus Deploy Tentacle'
recipe 'octopus-deploy::configure_tentacle', 'Installs and configures the Octopus Deploy Tentacle'
recipe 'octopus-deploy::server', 'Installs the Octopus Deploy Server'
recipe 'octopus-deploy::configure_server', 'Installs and configures the Octopus Deploy Server'
