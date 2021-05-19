require "time"

module Firebase
  module Admin
    module Auth
      # Fetches public key certificates used for signature verification.
      class CertificatesFetcher
        include Firebase::Admin::Internal::Utils

        # Constructs a new certificates fetcher.
        #
        # @param [String] url
        #   The certificates url to use when fetching public keys.
        def initialize(url)
          raise ArgumentError "url is invalid" unless validate_url(url)
          @url = url
          @certificates = {}
          @certificates_expire_at = Time.now
        end

        # Fetches certificates.
        #
        # @note
        #   Certificates are cached in memory and refreshed according to the cache-control header if present
        #   in the response.
        #
        # @return [Hash]
        def fetch_certificates!
          return @certificates unless should_refresh?
          keys, ttl = refresh
          @certificates_expire_at = Time.now + ttl
          @certificates = keys
        end

        private

        # Refreshes and returns the certificates
        def refresh
          res = connection.get(@url)
          match = res.headers["cache-control"]&.match(/max-age=([0-9]+)/)
          ttl = match&.captures&.first&.to_i || 0
          certificates = res.body
          [certificates, ttl]
        rescue => e
          raise CertificateRequestError, e.message
        end

        # Checks if keys need to be refreshed.
        #
        # @return [Boolean]
        def should_refresh?
          @certificates.nil? || @certificates.empty? || @certificates_expire_at < Time.now
        end

        def connection
          options = {
            headers: {
              Accept: "application/json; charset=utf-8",
              "User-Agent": USER_AGENT
            }
          }

          @connection ||= Faraday::Connection.new(options) do |c|
            c.use Faraday::Request::UrlEncoded
            c.use FaradayMiddleware::Mashify
            c.use Faraday::Response::ParseJson
            c.use Faraday::Response::RaiseError
            c.adapter(Faraday.default_adapter)
          end
        end
      end
    end
  end
end
