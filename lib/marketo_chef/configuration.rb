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

module MarketoChef
  # Store and validate Marketo client configuration data
  class Configuration
    FIELDS = %i[host client_id client_secret campaign_id].freeze

    attr_accessor :client_id, :client_secret, :campaign_id
    attr_reader :host

    def initialize(config = {})
      return unless config.any?

      config.map { |k, v| send("#{k}=", v) if FIELDS.include?(k) }
    end

    def host=(value)
      value = value.sub('mktoapi', 'mktorest')

      match = %r{https?:\/\/(.+)}.match(value)

      @host = match ? match[1] : value
    end

    def validate
      missing = ->(f) { !instance_variable_defined?(:"@#{f}") }
      bomb    = ->(f) { raise "Required Marketo configuration undefined: #{f}" }

      FIELDS.select(&missing).map(&bomb)
    end
  end
end
