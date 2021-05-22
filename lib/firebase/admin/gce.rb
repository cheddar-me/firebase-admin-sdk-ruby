require "faraday"
require "googleauth/compute_engine"

module Firebase
  module Admin
    module GCE
      # The compute engine metadata project id endpoint.
      PROJECT_ID_URI =
        "#{Google::Auth::GCECredentials.compute_check_uri}/computeMetadata/v1/project/project-id".freeze

      # Patches GCECredentials to lookup the project id using the metadata service when on compute engine.
      class ::Google::Auth::GCECredentials
        # The compute engine project id
        def project_id
          @project_id ||= fetch_project_id
        end

        private

        # Fetches the project id using the compute engine metadata service.
        def fetch_project_id
          connection = build_default_connection || Faraday.default_connection
          retry_with_error do
            uri = Firebase::Admin::GCE::PROJECT_ID_URI
            resp = connection.get(uri) do |req|
              req.headers["Metadata-Flavor"] = "Google"
            end
            case resp.status
            when 200
              resp.body
            when 404
              raise Signet::AuthorizationError, NO_METADATA_SERVER_ERROR
            else
              msg = "Unexpected error code #{resp.status} #{UNEXPECTED_ERROR_SUFFIX}"
              raise Signet::AuthorizationError, msg
            end
          end
        end
      end
    end
  end
end
