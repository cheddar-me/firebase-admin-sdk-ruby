require "jwt"

module Firebase
  module Admin
    module Auth
      # Base class for verifying Firebase JWTs.
      class JWTVerifier
        # Audience to use for Firebase Auth Custom tokens
        FIREBASE_AUDIENCE = "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit"

        # Initializes a new verifier.
        #
        # @param [Firebase::Admin::App] app
        #   The Firebase app to verify tokens for.
        # @param [String] certificates_url
        #   The url to load public key certificates used during token verification.
        def initialize(app, certificates_url)
          @project_id = app.project_id
          @certificates = CertificatesFetcher.new(certificates_url)
        end

        def verify(token, is_emulator = false)
          raise NotImplementedError if is_emulator
          decoded_token = JWT.decode(token, nil, !is_emulator, decode_options) do |header|
            find_key(header)
          end
          # manually verify the sub
          payload = decoded_token.first
          sub = payload["sub"]
          raise JWT::InvalidSubError, "Invalid subject." unless sub.is_a?(String) && !sub.empty?
          payload["uid"] = sub
          payload
        rescue JWT::ExpiredTokenError => e
          raise expired_error, e.message
        rescue JWT::DecodeError => e
          raise invalid_error, e.message
        end

        # Override in subclasses to set the issuer
        def issuer
          raise NotImplementedError
        end

        def invalid_error
          raise NotImplementedError
        end

        def expired_error
          raise NotImplementedError
        end

        private

        def decode_options
          {
            iss: issuer,
            aud: @project_id,
            algorithm: "RS256",
            verify_iat: true,
            verify_iss: true,
            verify_aud: true
          }
        end

        def find_key(header)
          return nil unless header["kid"].is_a?(String)
          certificate = @certificates.fetch_certificates![header[kid]]
          OpenSSL::X509::Certificate.new(certificate).public_key unless certificate.nil?
        end
      end

      # Verifier for Firebase ID tokens.
      class IDTokenVerifier < JWTVerifier
        ID_TOKEN_CERT_URI =
          "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

        private_constant :ID_TOKEN_CERT_URI

        # Initializes a new [IDTokenVerifier].
        #
        # @param [Firebase::Admin::App] app
        #   The Firebase app to verify tokens for.
        def initialize(app)
          super(app, ID_TOKEN_CERT_URI)
        end

        def issuer
          "https://securetoken.google.com/#{@project_id}"
        end

        def invalid_error
          InvalidTokenError
        end

        def expired_error
          ExpiredTokenError
        end
      end
    end
  end
end
