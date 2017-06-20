# frozen_string_literal: true

require 'forwardable'

require 'marketo_chef/client'
require 'marketo_chef/configuration'
require 'marketo_chef/version'

# Common usage of the Marketo API for our web properties
module MarketoChef
  # http://developers.marketo.com/rest-api/error-codes/#response_level_errors
  # 607: Daily API Request Limit Reached
  # 611: System Error (generic unhandled exception)
  # http://developers.marketo.com/rest-api/error-codes/#record_level_errors
  # 1001: Invalid value '%s'. Required of type '%s'
  # 1002: Missing value for required parameter '%s'
  # 1003: Invalid data
  # 1006: Field '%s' not found
  # 1007: Multiple leads match the lookup criteria
  # ...these are the only ones we might need to care about currently
  MAYBE_OUR_FAULT_CODES   = [1003, 1006].freeze
  MAYBE_THEIR_FAULT_CODES = [1001, 1002].freeze

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

      handle_skipped(lead, result) if result['status'] == 'skipped'

      trigger_campaign(campaign_id, result['id']) if result.key?('id')
    end

    private

    def sync(lead)
      response = Client.instance.sync_lead(lead)

      if response.key?('errors')
        capture_error("Lead Submission Error: #{response}\n#{lead}")
      end

      response['result']&.first
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

    def handle_skipped(lead, reasons)
      begin
        codes      = ->(c) { c['code'] }
        reportable = ->(c) { MAYBE_OUR_FAULT_CODES.include?(c) }
        feedback   = ->(r) { "#{r['code']}: #{r['message']}" }

        return unless reasons.collect(&codes).any?(&reportable)
      rescue TypeError => e
        skipped_lead_type_error(lead, reasons, e)
      end

      skipped_lead_error(lead, reasons, feedback)
    end

    def campaign_error(campaign_id, lead, errors)
      capture_error <<~ERR
        Campaign Triggering Error: #{errors}\n
        \tcampaign id: #{campaign_id}\n
        \tlead: #{lead}
      ERR
    end

    def skipped_lead_error(lead, reasons, feedback)
      capture_error <<~ERR
        Lead Submission Skipped:\n
        \tinput: #{lead}\n
        \t#{reasons.select(&reportable).collect(&feedback).join("\n\t")}
      ERR
    end

    def skipped_lead_type_error(lead, reasons, error)
      capture_error <<~ERR
        Unregognized Marketo Skipped Lead Error Response:\n
        \tLead: #{lead}\n
        \tReasons: #{reasons}\n
        \tError: #{error}
      ERR
    end
  end
end
