require "json"

module Firebase
  module Admin
    # The name of the environment variable to lookup a Firebase config.
    FIREBASE_CONFIG_ENV_VAR = "FIREBASE_CONFIG"

    # Configuration options used to initialize an App.
    class Config
      attr_reader :project_id, :service_account_id

      class << self
        # Loads a configuration using the FIREBASE_CONFIG environment variable.
        #
        # If the value of the FIREBASE_CONFIG environment variable starts with "{" it is
        # parsed as a JSON object, otherwise it is interpreted as a path to the config file.
        #
        # @return [Firebase::Admin::Config]
        def from_env
          config = ENV[FIREBASE_CONFIG_ENV_VAR]
          return new if config.nil?
          return from_json(config) if config.start_with?("{")
          from_file(config)
        end

        # Loads a configuration from a file.
        #
        # @param [File, String] file
        #   The path of the configuration file.
        #
        # @return [Firebase::Admin::Config]
        def from_file(file)
          json = file.is_a?(File) ? file.read : File.read(file)
          from_json(json)
        end

        # Loads a configuration from JSON.
        #
        # @param [String] json
        #   A configuration encoded as a JSON string.
        #
        # @return [Firebase::Admin::Config]
        def from_json(json)
          data = JSON.parse(json)
          new(project_id: data["projectId"],
              service_account_id: data["serviceAccountId"])
        end
      end

      # Initializes the configuration object.
      def initialize(project_id: nil, service_account_id: nil)
        @project_id = project_id
        @service_account_id = service_account_id
      end
    end
  end
end
