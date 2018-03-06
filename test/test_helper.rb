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

# remove these when we can configure client directly
ENV['MARKETO_HOST']          = '123-ABC-456.mktorest.com'
ENV['MARKETO_CLIENT_ID']     = 'c4206ec5-be87-465c-a0cc-99486a4c4e1b'
ENV['MARKETO_CLIENT_SECRET'] = 'Z5bzTySMrFdgcFZkSNvBywMuUen9ah7Q'
ENV['MARKETO_CAMPAIGN_ID']   = '1234'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'marketo_chef'

require 'minitest/autorun'
