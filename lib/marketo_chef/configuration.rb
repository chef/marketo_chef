# frozen_string_literal: true

module MarketoChef
  # Store and validate Marketo client configuration data
  class Configuration
    FIELDS = %i[host client_id client_secret campaign_id].freeze

    attr_accessor(*FIELDS)

    def initialize(config = {})
      config.each do |k, v|
        instance_variable_set("@#{k}", v) if FIELDS.include?(k.downcase.to_sym)
      end
    end

    def validate
      missing = ->(f) { !instance_variable_defined?(:"@#{f}") }
      bomb    = ->(f) { raise "Required Marketo configuration undefined: #{f}" }

      FIELDS.select(&missing).map(&bomb)
    end
  end
end
