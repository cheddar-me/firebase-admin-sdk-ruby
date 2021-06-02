require "json"

module Firebase
  module Admin
    module Auth
      # Standard profile information for a user.
      #
      # Also used to expose profile information returned by an identity provider.
      class UserInfo
        # Constructs a new UserInfo.
        #
        # @param [Hash] data
        #   A hash of profile information
        def initialize(data)
          @data = data || {}
        end

        # Gets the ID of this user.
        def uid
          @data["rawId"]
        end

        # Gets the display name of this user.
        def display_name
          @data["displayName"]
        end

        # Gets the email address associated with this user.
        def email
          @data["email"]
        end

        # Gets the phone number associated with this user.
        def phone_number
          @data["phoneNumber"]
        end

        # Gets the photo url of this user.
        def photo_url
          @data["photoUrl"]
        end

        # Gets the id of the identity provider.
        #
        # This can be a short domain name (e.g. google.com), or the identity of an OpenID
        # identity provider.
        def provider_id
          @data["providerId"]
        end

        # Converts the object into a hash.
        #
        # @return [Hash]
        def to_h
          @data.dup
        end
      end
    end
  end
end
