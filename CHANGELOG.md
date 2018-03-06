# Change Log

## [v0.13.1](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.13.1) (2018-03-05)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.13.0...v0.13.1)

**Merged pull requests:**

- Fix an issue with registering tentacles with tenated\_deployment\_participation not specified [\#136](https://github.com/cvent/octopus-deploy-cookbook/pull/136) ([brentm5](https://github.com/brentm5))
- Correct readme database instructions [\#133](https://github.com/cvent/octopus-deploy-cookbook/pull/133) ([spuder](https://github.com/spuder))

## [v0.13.0](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.13.0) (2018-03-05)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.12.0...v0.13.0)

**Merged pull requests:**

- Allow tentacle to run as untenanted [\#130](https://github.com/cvent/octopus-deploy-cookbook/pull/130) ([spuder](https://github.com/spuder))
- Add tentacle install\_url to override default installer url [\#128](https://github.com/cvent/octopus-deploy-cookbook/pull/128) ([brentm5](https://github.com/brentm5))
- Make cookbook works for chef 13+ [\#125](https://github.com/cvent/octopus-deploy-cookbook/pull/125) ([brentm5](https://github.com/brentm5))
- Bump chef\_version in metadata to 12.6.0 [\#116](https://github.com/cvent/octopus-deploy-cookbook/pull/116) ([spuder](https://github.com/spuder))
- Bump windows cookbook dependency [\#111](https://github.com/cvent/octopus-deploy-cookbook/pull/111) ([spuder](https://github.com/spuder))
- Update bundler and lock appveyor chefdk version to specific version [\#109](https://github.com/cvent/octopus-deploy-cookbook/pull/109) ([brentm5](https://github.com/brentm5))
- Adds default node name for server resource [\#108](https://github.com/cvent/octopus-deploy-cookbook/pull/108) ([spuder](https://github.com/spuder))
- Adds chef\_version requirement to metadata.rb [\#106](https://github.com/cvent/octopus-deploy-cookbook/pull/106) ([spuder](https://github.com/spuder))
- Validate connection\_string in configure service resource [\#103](https://github.com/cvent/octopus-deploy-cookbook/pull/103) ([spuder](https://github.com/spuder))

## [v0.12.0](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.12.0) (2017-05-25)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.11.0...v0.12.0)

**Merged pull requests:**

- Update the server resource to use the new style in resources [\#96](https://github.com/cvent/octopus-deploy-cookbook/pull/96) ([brentm5](https://github.com/brentm5))
- Update tentacle resource to work with new resource declarations [\#94](https://github.com/cvent/octopus-deploy-cookbook/pull/94) ([brentm5](https://github.com/brentm5))
- Update tools resource to work with new resource declarations [\#93](https://github.com/cvent/octopus-deploy-cookbook/pull/93) ([brentm5](https://github.com/brentm5))

## [v0.11.0](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.11.0) (2017-05-08)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.10.1...v0.11.0)

**Merged pull requests:**

- Use sensitive attribute for server resource instead of debug [\#89](https://github.com/cvent/octopus-deploy-cookbook/pull/89) ([brentm5](https://github.com/brentm5))
- Removes the Server resources delayed restart [\#83](https://github.com/cvent/octopus-deploy-cookbook/pull/83) ([brentm5](https://github.com/brentm5))

## [v0.10.1](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.10.1) (2017-04-13)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.10.0...v0.10.1)

**Merged pull requests:**

- This adds a debug parameter to the server resource [\#81](https://github.com/cvent/octopus-deploy-cookbook/pull/81) ([brentm5](https://github.com/brentm5))

## [v0.10.0](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.10.0) (2017-01-05)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.9.0...v0.10.0)

**Merged pull requests:**

- Add tools resource to allow installing of octopus deploy tools [\#77](https://github.com/cvent/octopus-deploy-cookbook/pull/77) ([brentm5](https://github.com/brentm5))

## [v0.9.0](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.9.0) (2016-11-10)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.8.0...v0.9.0)

**Merged pull requests:**

- Add attribute to allow public hostname to be specified on tentacle register [\#74](https://github.com/cvent/octopus-deploy-cookbook/pull/74) ([Draftkings](https://github.com/Draftkings))
- Update README with correct capitalization of Tentacle [\#73](https://github.com/cvent/octopus-deploy-cookbook/pull/73) ([vanessalove](https://github.com/vanessalove))

## [v0.8.0](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.8.0) (2016-11-01)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.7.0...v0.8.0)

**Merged pull requests:**

- Add ability to run tentacle as a specific AD user [\#71](https://github.com/cvent/octopus-deploy-cookbook/pull/71) ([gdavison](https://github.com/gdavison))
- Add attribute to allow tentacle name to be changed on register  [\#70](https://github.com/cvent/octopus-deploy-cookbook/pull/70) ([gdavison](https://github.com/gdavison))

## [v0.7.0](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.7.0) (2016-10-04)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.6.5...v0.7.0)

**Merged pull requests:**

- Loosen up dependency version locking [\#68](https://github.com/cvent/octopus-deploy-cookbook/pull/68) ([blairham](https://github.com/blairham))
- Updates readme to clarify tenant tag grouping [\#67](https://github.com/cvent/octopus-deploy-cookbook/pull/67) ([spuder](https://github.com/spuder))

## [v0.6.5](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.6.5) (2016-09-21)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.6.4...v0.6.5)

**Merged pull requests:**

- Allow multiple environments when registering tentacles [\#65](https://github.com/cvent/octopus-deploy-cookbook/pull/65) ([gdavison](https://github.com/gdavison))

## [v0.6.4](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.6.4) (2016-09-07)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.6.3...v0.6.4)

**Merged pull requests:**

- Adds tenant and tentanttag support [\#61](https://github.com/cvent/octopus-deploy-cookbook/pull/61) ([spuder](https://github.com/spuder))
- Fix option\_list methods handling of nils [\#60](https://github.com/cvent/octopus-deploy-cookbook/pull/60) ([spuder](https://github.com/spuder))

## [v0.6.3](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.6.3) (2016-08-18)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.6.2...v0.6.3)

**Merged pull requests:**

- Fix issue in notifying tentacle service restart on tentacle register [\#57](https://github.com/cvent/octopus-deploy-cookbook/pull/57) ([spuder](https://github.com/spuder))
- Restarts tentacle service when registering [\#56](https://github.com/cvent/octopus-deploy-cookbook/pull/56) ([spuder](https://github.com/spuder))

## [v0.6.2](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.6.2) (2016-08-16)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.6.1...v0.6.2)

**Merged pull requests:**

- Change tentacle install parameters to be more quiet [\#52](https://github.com/cvent/octopus-deploy-cookbook/pull/52) ([brentm5](https://github.com/brentm5))

## [v0.6.1](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.6.1) (2016-08-15)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.6.0...v0.6.1)

**Merged pull requests:**

- Add unit test to validate library assumptions [\#49](https://github.com/cvent/octopus-deploy-cookbook/pull/49) ([brentm5](https://github.com/brentm5))
- Refactor registering tentacle resource [\#47](https://github.com/cvent/octopus-deploy-cookbook/pull/47) ([brentm5](https://github.com/brentm5))

## [v0.6.0](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.6.0) (2016-08-08)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.5.1...v0.6.0)

**Merged pull requests:**

- Set tentacle register environment default to be the chef environment [\#45](https://github.com/cvent/octopus-deploy-cookbook/pull/45) ([spuder](https://github.com/spuder))
- Add ability for the tentacle resource to setup firewall rule for listening tentacles [\#43](https://github.com/cvent/octopus-deploy-cookbook/pull/43) ([spuder](https://github.com/spuder))
- Add changelog generator and first changelog file [\#39](https://github.com/cvent/octopus-deploy-cookbook/pull/39) ([brentm5](https://github.com/brentm5))
- Add ability to register tentacle with server through tentacle resource  [\#33](https://github.com/cvent/octopus-deploy-cookbook/pull/33) ([spuder](https://github.com/spuder))
- Include optional master key attribute for configuring a server instance [\#25](https://github.com/cvent/octopus-deploy-cookbook/pull/25) ([brentm5](https://github.com/brentm5))

## [v0.5.1](https://github.com/cvent/octopus-deploy-cookbook/tree/v0.5.1) (2016-04-04)
[Full Changelog](https://github.com/cvent/octopus-deploy-cookbook/compare/v0.5.0...v0.5.1)

**Merged pull requests:**

- Fix issue with notifying service to restart when its disabled! [\#22](https://github.com/cvent/octopus-deploy-cookbook/pull/22) ([brentm5](https://github.com/brentm5))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*