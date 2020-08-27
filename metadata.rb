# frozen_string_literal: true
name 'octopus-deploy'
maintainer 'Montague, Brent'
maintainer_email 'BMontague@cvent.com'
license 'Apache-2.0'
description 'Handles installing Octopus Deploy Server &| Tentacle'
source_url 'https://github.com/cvent/octopus-deploy-cookbook'
issues_url 'https://github.com/cvent/octopus-deploy-cookbook/issues'
version '0.13.3'

depends 'windows'
depends 'windows_firewall', '~> 3.0'
supports 'windows'

chef_version '>= 12.6.0'
