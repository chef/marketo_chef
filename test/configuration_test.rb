# frozen_string_literal: true

require 'test_helper'

class ConfigurationTest < Minitest::Test
  def setup
    @config_data = {
      host:          ENV['MARKETO_HOST'],
      client_id:     ENV['MARKETO_CLIENT_ID'],
      client_secret: ENV['MARKETO_CLIENT_SECRET'],
      campaign_id:   ENV['MARKETO_CAMPAIGN_ID']
    }
  end

  def test_that_you_can_configure
    cfg = ::MarketoChef::Configuration.new(@config_data)

    assert cfg.host == ENV['MARKETO_HOST']
  end

  def test_wrong_hostname
    cfg = ::MarketoChef::Configuration.new(
      @config_data.merge(host: '123-ABC-456.mktoapi.com')
    )
    assert cfg.host == '123-ABC-456.mktorest.com'
  end

  def test_bad_hosts_handled
    cfg = ::MarketoChef::Configuration.new(
      @config_data.merge(host: 'http://' + ENV['MARKETO_HOST'])
    )
    assert cfg.host == ENV['MARKETO_HOST']
  end
end
