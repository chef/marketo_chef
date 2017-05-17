# frozen_string_literal: true

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
