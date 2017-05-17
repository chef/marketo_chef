# frozen_string_literal: true

require 'test_helper'

class ConfigurationTest < Minitest::Test
  def test_that_you_can_configure
    cfg = ::MarketoChef::Configuration.new(
      host:          ENV['MARKETO_HOST'],
      client_id:     ENV['MARKETO_CLIENT_ID'],
      client_secret: ENV['MARKETO_CLIENT_SECRET'],
      campaign_id:   ENV['MARKETO_CAMPAIGN_ID']
    )
    assert cfg.host == ENV['MARKETO_HOST']
  end
end
