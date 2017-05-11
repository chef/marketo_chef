# MarketoChef

This gem defines a Marketo API client providing a simple interface to our
single common use case: adding a lead to the Marketo database and assigning it
to a specific campaign.

## Installation

Add this line to your application's Gemfile:

```ruby gem 'marketo_chef' ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marketo_chef

## Usage

The gem currently expects to be configured solely via environment variables.

Required environment variables, with bogus example values:
```shell
MARKETO_HOST="123-ABC-456.mktorest.com"
MARKETO_CLIENT_ID="c4206ec5-be87-465c-a0cc-99486a4c4e1b"
MARKETO_CLIENT_SECRET="Z5bzTySMrFdgcFZkSNvBywMuUen9ah7Q"
MARKETO_CAMPAIGN="1234"
```

There is a single public method exposed, and it expects a hash of lead data.

Required keys, with bogus example values:
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

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/chef/marketo_chef.
