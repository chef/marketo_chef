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

require 'forwardable'

require 'marketo_chef/client'
require 'marketo_chef/configuration'
require 'marketo_chef/version'

# Common usage of the Marketo API for our web properties
module MarketoChef
  # http://developers.marketo.com/rest-api/error-codes/#response_level_errors
  # 607: Daily API Request Limit Reached
  # 611: System Error (generic unhandled exception)
  RESPONSE_ERROR_CODES = %w[607 611].freeze

  # http://developers.marketo.com/rest-api/error-codes/#record_level_errors
  # 1001: Invalid value '%s'. Required of type '%s'
  # 1002: Missing value for required parameter '%s'
  # 1003: Invalid data
  # 1006: Field '%s' not found
  # 1007: Multiple leads match the lookup criteria
  # ...these are the only ones we might need to care about currently
  MAYBE_OUR_FAULT_CODES   = %w[1003 1006].freeze
  MAYBE_THEIR_FAULT_CODES = %w[1001 1002].freeze

  class << self
    extend Forwardable

    def_delegators :configuration,
                   :campaign_id, :client_id, :client_secret, :host

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)

      configuration.validate
    end

    def add_lead(lead)
      result = sync(lead)

      return unless result

      handle_skipped(lead, result['reasons']) if result['status'] == 'skipped'

      trigger_campaign(campaign_id, result['id']) if result.key?('id')
    end

    private

    def sync(lead)
      response = Client.instance.sync_lead(lead)

      if response.key?('errors')
        handle_response_err(response)
      else
        response['result']&.first
      end
    end

    def trigger_campaign(campaign_id, lead_id)
      response = Client.instance.trigger_campaign(campaign_id, lead_id)

      campaign_error(campaign_id, lead_id, response) if response.key?('errors')

      response
    end

    def capture_error(message)
      puts message
      Raven.capture_exception(Exception.new(message))
    end

    def handle_response_err(response)
      codes      = ->(c) { c['code'] }
      known      = ->(c) { RESPONSE_ERROR_CODES.include?(c) }
      feedback   = ->(r) { "#{r['code']}: #{r['message']}" }

      return if reasons.collect(&codes).any?(&known)

      response_error(response.reject(&known).collect(&feedback))
    end

    def handle_skipped(lead, reasons)
      codes      = ->(c) { c['code'] }
      reportable = ->(c) { MAYBE_OUR_FAULT_CODES.include?(c) }
      feedback   = ->(r) { "#{r['code']}: #{r['message']}" }

      return unless reasons.collect(&codes).any?(&reportable)

      skipped_lead_error(lead, reasons.collect(&feedback))
    rescue TypeError => error
      skipped_lead_type_error(lead, reasons, error)
    end

    def response_error(reasons)
      capture_error <<~ERR
        Response Error:\n
        \t#{reasons.join("\n\t")}
      ERR
    end

    def campaign_error(campaign_id, lead, errors)
      capture_error <<~ERR
        Campaign Triggering Error: #{errors}\n
        \tcampaign id: #{campaign_id}\n
        \tlead: #{lead}
      ERR
    end

    def skipped_lead_error(lead, reasons)
      capture_error <<~ERR
        Lead Submission Skipped:\n
        \tinput: #{lead}\n
        \t#{reasons.join("\n\t")}
      ERR
    end

    def skipped_lead_type_error(lead, reasons, error)
      capture_error <<~ERR
        Something went wrong trying to parse this skipped lead response:\n
        \tLead: #{lead}\n
        \tReasons: #{reasons}\n
        \tError: #{error}
      ERR
    end
  end
end
