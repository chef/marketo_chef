# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.1.0] - 2018.03.06
### Added
- Gem is now licensed Apache 2.0

### Changed
- Allow pushing the gem to RubyGems.org

## [1.0.2] - 2017.07.06
### Changed
- Marketo error codes are declared as Strings
- Pass the `reasons` array from the response to `handle_skipped`

## [1.0.1] - 2017.06.27
### Added
- Release history via CHANGELOG.md
- Documentation via README.md
- Checking response for communication failure (2d9f5c822a95187968944420998dc741fb8f2024)

### Changed
- Error handling around response-level errors
- Lower required Faraday version due to transitive dependencies in client
  applications (ce4109847c3569c1f2b442d32a530e32b8ae74bd)

## [0.1.0] - 2017.05.05
### Added
- Method to add lead, assign to campaign
