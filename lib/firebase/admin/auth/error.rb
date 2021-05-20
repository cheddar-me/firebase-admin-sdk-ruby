module Firebase
  module Admin
    module Auth
      # A base class for errors raised by the admin sdk auth client.
      class Error < Firebase::Admin::Error; end

      # Raised when a request for certificates fails.
      class CertificateRequestError < Error; end

      # Raised when id token verification fails.
      class InvalidTokenError < Error; end

      # Raised when id token verification fails because the token is expired.
      class ExpiredTokenError < Error; end
    end
  end
end
