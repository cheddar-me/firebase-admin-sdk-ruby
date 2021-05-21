require "time"
require "monitor"

module Firebase
  module Admin
    module Auth
      # Fetches public key certificates used for signature verification.
      class CertificatesFetcher
        include Utils

        # Constructs a new certificates fetcher.
        #
        # @param [String] url
        #   The certificates url to use when fetching public keys.
        def initialize(url)
          raise ArgumentError "url is invalid" unless validate_url(url)
          @url = url
          @certificates = {}
          @certificates_expire_at = Time.now
          @monitor = Monitor.new
          @client = Firebase::Admin::Internal::HTTPClient.new
        end

        # Fetches certificates.
        #
        # @note
        #   Certificates are cached in memory and refreshed according to the cache-control header if present
        #   in the response.
        #
        # @return [Hash]
        def fetch_certificates!
          @monitor.synchronize do
            return @certificates unless should_refresh?
            keys, ttl = refresh
            @certificates_expire_at = Time.now + ttl
            @certificates = keys
          end
        end

        private

        # Refreshes and returns the certificates
        def refresh
          res = @client.get(@url)
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
      end
    end
  end
end
