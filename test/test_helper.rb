# frozen_string_literal: true

# remove these when we can configure client directly
ENV['MARKETO_HOST']          = '123-ABC-456.mktorest.com'
ENV['MARKETO_CLIENT_ID']     = 'c4206ec5-be87-465c-a0cc-99486a4c4e1b'
ENV['MARKETO_CLIENT_SECRET'] = 'Z5bzTySMrFdgcFZkSNvBywMuUen9ah7Q'
ENV['MARKETO_CAMPAIGN_ID']   = '1234'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'marketo_chef'

require 'minitest/autorun'
