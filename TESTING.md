Testing this cookbook
=====

This cookbook includes the following tests:

* Unit tests via Rspec
* Static Code analysis via Cookstyle / Rubocop
* Linting via Foodcritic
* Integration tests via Test Kitchen

Contributions to this cookbook will only be accepted if all tests pass successfully


Running Tests
-----

In order to run all the tests (except integration tests) you can run the following:

```bash
bundle exec rake
```


Running Test Kitchen
-----

In order to run test kitchen locally you need to have access to a windows virtualbox
image. Until there is an easier way to test locally it's fine to only be
tested on appveyor during PR's.
