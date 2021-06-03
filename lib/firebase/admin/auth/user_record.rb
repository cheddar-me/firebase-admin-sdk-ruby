require "json"

module Firebase
  module Admin
    module Auth
      # A Firebase User account
      class UserRecord < UserInfo
        # Gets the ID of this user.
        def uid
          @data["localId"]
        end

        # Gets the id of the identity provider.
        #
        # Always firebase for user accounts.
        def provider_id
          "firebase"
        end

        def email_verified?
          !!@data["emailVerified"]
        end

        def disabled?
          !!@data["disabled"]
        end

        # Gets the time, in milliseconds since the epoch, before which tokens are invalid.
        #
        # @note truncated to 1 second accuracy.
        #
        # @return [Numeric]
        #   Timestamp in milliseconds since the epoch, truncated to the second.
        #   All tokens issued before that time are considered revoked.
        def tokens_valid_after_timestamp
          raise NotImplementedError
        end

        # Gets additional metadata associated with this user.
        #
        # @return [UserMetadata]
        def user_metadata
          raise NotImplementedError
        end

        # Gets a list of (UserInfo) instances.
        #
        # Each object represents an identity from an identity provider that is linked to this user.
        #
        # @return [Array of UserInfo]
        def provider_data
          providers = @data["providerUserInfo"] || []
          providers.to_a.map { |p| UserInfo.new(p) }
        end

        # Gets any custom claims set on this user account.
        def custom_claims
          claims = @data["customAttributes"]
          parsed = JSON.parse(claims) unless claims.nil?
          parsed if parsed.is_a?(Hash) && !parsed.empty?
        end

        # Returns the tenant ID of this user.
        def tenant_id
          raise NotImplementedError
        end
      end
    end
  end
end
