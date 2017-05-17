# frozen_string_literal: true

require 'test_helper'

class MarketoChefTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MarketoChef::VERSION
  end

  def test_that_it_does_something_useful
    assert ::MarketoChef.respond_to? :add_lead
  end

  def test_that_it_can_be_configured
    ::MarketoChef.configure do |c|
      c.host          = ENV['MARKETO_HOST']
      c.client_id     = ENV['MARKETO_CLIENT_ID']
      c.client_secret = ENV['MARKETO_CLIENT_SECRET']
      c.campaign_id   = ENV['MARKETO_CAMPAIGN_ID']
    end
    assert MarketoChef.host == ENV['MARKETO_HOST']
  end
end
