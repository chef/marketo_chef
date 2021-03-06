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

require 'json'
require 'singleton'

require 'faraday'
require 'faraday_middleware'

module MarketoChef
  # Faraday wrapper to handle communication with Marketo API
  class Client
    include Singleton
    extend Forwardable

    def_delegators :MarketoChef, :client_id, :client_secret, :host

    def sync_lead(lead)
      authenticate!

      connection.post do |req|
        req.url '/rest/v1/leads.json'
        req.headers[:authorization] = "Bearer #{@token}"
        req.body = { action: 'createOrUpdate', input: [lead] }
      end.body
    end

    def trigger_campaign(campaign_id, lead_id)
      authenticate!

      connection.post do |req|
        req.url "/rest/v1/campaigns/#{campaign_id}/trigger.json"
        req.headers[:authorization] = "Bearer #{@token}"
        req.body = { input: { leads: [{ id: lead_id }] } }
      end.body
    end

    private

    def connection
      @connection ||= Faraday.new(url: "https://#{host}") do |conn|
        conn.request  :multipart
        conn.request  :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter  Faraday.default_adapter
      end
    end

    def authenticate!
      authenticate unless authenticated?
    end

    def authenticated?
      @token && valid_token?
    end

    def valid_token?
      return false unless defined?(@valid_until)

      Time.now < @valid_until
    end

    def authenticate
      connection.get('/identity/oauth/token', auth_params).tap do |res|
        inspect_auth_response(res.body)

        save_authentication(res.body)
      end
    end

    def inspect_auth_response(body)
      # res.body may be an HTML string, "The document has moved" message,
      # which occurs if the host is mktoapi.com instead of mktorest.com.
      raise body if body.is_a?(String)
      raise body['errors'][0]['message'] if body.key?('errors')
    end

    def auth_params
      {
        grant_type:    'client_credentials',
        client_id:     client_id,
        client_secret: client_secret
      }
    end

    def save_authentication(data)
      @token       = data.fetch('access_token')
      @token_type  = data.fetch('token_type')
      @valid_until = Time.now + data.fetch('expires_in')
      @scope       = data.fetch('scope')
    end
  end
end
