require "jwt"

module Firebase
  module Admin
    module Auth
      # Verifies ID tokens and session cookies.
      class TokenVerifier
        # Audience to use for Firebase Auth Custom tokens
        FIREBASE_AUDIENCE =
          "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit".freeze

        # Location of the public keys for the Google certs (whose private keys are used to sign Firebase Auth ID tokens)
        CLIENT_CERT_URI =
          "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com".freeze

        # Location of the public keys for Firebase session cookies.
        SESSION_COOKIE_CERT_URL = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/publicKeys".freeze

        # Initializes a new verifier.
        #
        # @param [String] project_id
        #   The Firebase project id
        def initialize(project_id:, short_name:, doc_uri:, cert_uri:, issuer:, invalid_error:, expired_error:)
          @project_id = project_id
          @short_name = short_name
          @doc_uri = doc_uri
          @cert_uri = cert_uri
          @issuer = issuer
          @invalid_error = invalid_error
          @expired_error = expired_error
        end

        def verify_jwt(token, is_emulator = false)
          raise NotImplementedError if is_emulator
          decoded = decode_and_verify(token, is_emulator)
          decoded[:uid] = decoded[:sub]
        end

        private

        def decode_and_verify(token, is_emulator)
          raise NotImplementedError
        end
      end
    end
  end
end
