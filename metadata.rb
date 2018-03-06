# frozen_string_literal: true
name 'octopus-deploy'
maintainer 'Montague, Brent'
maintainer_email 'BMontague@cvent.com'
license 'Apache-2.0'
description 'Handles installing Octopus Deploy Server &| Tentacle'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/cvent/octopus-deploy-cookbook'
issues_url 'https://github.com/cvent/octopus-deploy-cookbook/issues'
version '0.13.1'

depends 'windows'
depends 'windows_firewall', '~> 3.0'
supports 'windows'

provides 'octopus_deploy_server[OctopusServer]'
provides 'octopus_deploy_tentacle[Tentacle]'
provides 'octopus_deploy_tools[C:\octopus]'

chef_version '>= 12.6.0' if respond_to?(:chef_version)
