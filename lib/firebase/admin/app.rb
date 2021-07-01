# frozen_string_literal: true

require_relative "error"
require_relative "config"
require_relative "credentials"
require_relative "auth/client"

module Firebase
  module Admin
    # An App holds configuration and state common to all Firebase services that are exposed from the SDK.
    class App
      attr_reader :project_id, :service_account_id, :credentials

      # Constructs a new App.
      #
      # @param [Credentials] credentials
      #   Credentials for authenticating with Firebase.
      # @param [Config] config
      #   Firebase configuration options.
      def initialize(credentials: nil, config: nil)
        @config = config || Config.from_env
        @credentials = credentials || Credentials.from_default
        @service_account_id = @config.service_account_id
        @project_id = @config.project_id || @credentials.project_id
      end
    end
  end
end
