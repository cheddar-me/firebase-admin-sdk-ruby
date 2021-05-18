require "stringio"
require "googleauth/default_credentials"
require "googleauth/application_default"

module Firebase
  module Admin
    SCOPE = %w[
      https://www.googleapis.com/auth/cloud-platform
      https://www.googleapis.com/auth/datastore
      https://www.googleapis.com/auth/devstorage.read_write
      https://www.googleapis.com/auth/firebase
      https://www.googleapis.com/auth/identitytoolkit
      https://www.googleapis.com/auth/userinfo.email
    ]

    # Firebase credentials.
    class Credentials
      class << self
        # Loads google credentials from a specified file path.
        #
        # @param [File, String] file
        #   The credentials file path
        #
        # @return [Firebase::Admin::Credentials]
        def from_file(file)
          json = file.is_a?(File) ? file.read : File.read(file)
          from_json(json)
        end

        # Loads google credentials from a JSON string.
        #
        # @param [String] json
        #   A JSON string containing valid google credentials.
        #
        # @return [Firebase::Admin::Credentials]
        def from_json(json)
          io = StringIO.new(json)
          new(Google::Auth::DefaultCredentials.make_creds(scope: SCOPE, json_key_io: io))
        end

        # Loads application default credentials.
        #
        # @return [Firebase::Admin::Credentials]
        def from_default
          new(Google::Auth.get_application_default(SCOPE))
        end
      end

      # Gets the google credentials
      attr_reader :credentials

      # Gets the google project id
      def project_id
        @credentials&.project_id
      end

      # Apply the credentials
      def apply!(hash, opts = {})
        @credentials.apply!(hash, opts)
      end

      # Constructs a Credential from the specified Google Credentials.
      #
      # @param [Google::Auth::ServiceAccountCredentials, Google::Auth::UserRefreshCredentials, Google::Auth::GCECredentials] credentials
      #   The google credentials to connect with.
      def initialize(credentials)
        raise ArgumentError, "credentials cannot be nil" if credentials.nil?
        @credentials = credentials
      end
    end
  end
end
