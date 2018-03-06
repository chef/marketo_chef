# MarketoChef

This gem defines a Marketo API client providing a simple interface to our
single common use case: adding a lead to the Marketo database and assigning it
to a specific campaign.

[![Build Status](https://travis-ci.com/chef/marketo_chef.svg?token=QMKWuXEPx23uB8JGd4tb&branch=master)](https://travis-ci.com/chef/marketo_chef)

## Installation

Add this line to your application's Gemfile:

```ruby gem 'marketo_chef' ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marketo_chef

## Usage

The gem expects client code to configure it before use. Like so:
```ruby
MarketoChef.configure do |c|
  c.host          = ENV['MARKETO_HOST']
  c.client_id     = ENV['MARKETO_CLIENT_ID']
  c.client_secret = ENV['MARKETO_CLIENT_SECRET']
  c.campaign_id   = ENV['MARKETO_CAMPAIGN_ID']
end
```
Conventionally this would be added to an initializer in Rails or Hanami, for
example in a file `config/initializers/01_marketo_chef.rb`, with Rails. This
ensures the application will attempt to configure the gem at start time rather
than later, when discovering that configuration values aren't available
(perhaps an environment variable name is incorrect) will generate unexpected
errors.

Required environment variables, with bogus example values:
```shell
MARKETO_HOST="123-ABC-456.mktorest.com"
MARKETO_CLIENT_ID="c4206ec5-be87-465c-a0cc-99486a4c4e1b"
MARKETO_CLIENT_SECRET="Z5bzTySMrFdgcFZkSNvBywMuUen9ah7Q"
MARKETO_CAMPAIGN_ID="1234"
```

The gem exposes a single method for lead tracking, which accepts a hash of lead
data, creates or updates the lead in Marketo, and adds it to the specified
campaign.

```ruby
MarketoChef.add_lead(
  'formname':         'Some Form',
  'product-interest': 'some-interest',
  'firstName':        'Jane',
  'lastName':         'Doe',
  'email':            'jdoe@example.com',
  'company':          'ExampleCo'
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

You can also run `rubocop` to verify style guide adherence. It happens along
with the tests in CI, but better to catch those problems before committing and
pushing and so on.

To install this gem onto your local machine, run `bundle exec rake install`.

### Releasing

To release a new version:
1. increment the version number in `version.rb`
2. update `CHANGELOG.md` with additions, changes, or removals
3. commit the above and tag that commit for the version (ex: `git tag -s -m 'v1.1.0 - Public release' v1.1.0 abcdefg`)
4. push commits and tags to github (ex: `git push origin master --tags`)
5. push gem to RubyGems.org (ex: `gem push marketo_chef-1.1.0.gem`)

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/chef/marketo_chef.
