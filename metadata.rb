name 'octopus-deploy'
maintainer 'Montague, Brent'
maintainer_email 'BMontague@cvent.com'
license 'Apache 2.0'
description 'Handles installing Octopus Deploy Server &| Tentacle'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/cvent/octopus-deploy-cookbook'
issues_url 'https://github.com/cvent/octopus-deploy-cookbook/issues'
version '0.9.0'

depends 'windows', '>= 1.38.0'
depends 'windows_firewall', '~> 3.0'
supports 'windows'

provides 'octopus_deploy_server[OctopusServer]'
provides 'octopus_deploy_tentacle[Tentacle]'
provides 'octopus_deploy_tools[C:\octopus]'
