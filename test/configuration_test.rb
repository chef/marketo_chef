# frozen_string_literal: true

# Copyright 2018 Chef Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
