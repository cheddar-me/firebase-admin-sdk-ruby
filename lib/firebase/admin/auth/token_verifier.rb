require "jwt"
require "openssl/x509"

module Firebase
  module Admin
    module Auth
      # Base class for verifying Firebase JWTs.
      class JWTVerifier
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

        # Verifies a Firebase ID token.
        #
        # @param [String] token A Firebase JWT ID token.
        # @param [Boolean] is_emulator skips signature verification if true.
        # @return [Hash] the verified claims.
        def verify(token, is_emulator: false)
          payload = decode(token, is_emulator).first
          sub = payload["sub"]
          raise JWT::InvalidSubError, "Invalid subject." unless sub.is_a?(String) && !sub.empty?
          payload["uid"] = sub
          payload
        rescue JWT::ExpiredSignature => e
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
          certificate = @certificates.fetch_certificates![header["kid"]]
          OpenSSL::X509::Certificate.new(certificate).public_key unless certificate.nil?
        rescue OpenSSL::X509::CertificateError => e
          raise InvalidCertificateError, e.message
        end

        def decode(token, is_emulator)
          return decode_unsigned(token) if is_emulator
          JWT.decode(token, nil, true, decode_options) do |header|
            find_key(header)
          end
        end

        def decode_unsigned(token)
          raise InvalidTokenError, "token must not be nil" unless token
          raise InvalidTokenError, "token must be a string" unless token.is_a?(String)
          raise InvalidTokenError, "The auth emulator only accepts unsigned ID tokens." unless token.split(".").length == 2
          options = decode_options.merge({algorithm: "none"})
          JWT.decode(token, nil, false, options)
        end
      end

      # Verifier for Firebase ID tokens.
      class IDTokenVerifier < JWTVerifier
        CERTIFICATES_URI =
          "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

        # Initializes a new [IDTokenVerifier].
        #
        # @param [Firebase::Admin::App] app
        #   The Firebase app to verify tokens for.
        def initialize(app)
          super(app, CERTIFICATES_URI)
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
