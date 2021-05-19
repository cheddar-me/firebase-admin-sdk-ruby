module Firebase
  module Admin
    module Auth
      ID_TOOLKIT_URL = "https://identitytoolkit.googleapis.com"

      class Client
        include Firebase::Admin::Client
        include Firebase::Admin::Internal::Utils

        # Constructs an AuthClient
        def initialize(app)
          @project_id = app.project_id
          @service_account_id = app.service_account_id
          @credentials = app.credentials
          @base_url = ID_TOOLKIT_URL
          @base_path = "/v1/projects/#{@project_id}"
          @id_token_verifier = IDTokenVerifier.new(app)
        end

        # Creates a new user account with the specified properties.
        #
        # @param [String] uid
        #   The id to assign to the newly created user.
        # @param [String] display_name
        #   The user’s display name.
        # @param [String] email
        #   The user’s primary email (optional).
        # @param [String] email_verified
        #   A boolean indicating whether or not the user’s primary email is verified.
        # @param [String] phone_number
        #   The user’s primary phone number.
        # @param [String] photo_url
        #   The user’s photo URL.
        # @param [String] password
        #   The user’s raw, unhashed password.
        # @param [Boolean] disabled
        #   A boolean indicating whether or not the user account is disabled.
        #
        # @return [UserRecord]
        def create_user(uid: nil, display_name: nil, email: nil, email_verified: nil, phone_number: nil, photo_url: nil, password: nil, disabled: nil)
          payload = {
            localId: validate_uid(uid),
            displayName: validate_display_name(display_name),
            email: validate_email(email),
            phoneNumber: validate_phone_number(phone_number),
            photoUrl: validate_photo_url(photo_url),
            password: validate_password(password),
            emailVerified: to_boolean(email_verified),
            disabled: to_boolean(disabled)
          }.compact!
          res = request(:post, "#{@base_path}/accounts", payload)
          uid = res&.fetch(:localId)
          raise Error, "failed to create new user #{res}" if uid.nil?
          get_user(uid)
        end

        # Gets the user corresponding to the specified user id.
        #
        # @param [String] uid
        #   The id of the user.
        #
        # @return [UserRecord]
        def get_user(uid)
          get_user_by(uid: uid)
        end

        # Gets the user corresponding to the specified email address.
        #
        # @param [String] email
        #   An email address.
        #
        # @return [UserRecord]
        def get_user_by_email(email)
          get_user_by(email: email)
        end

        # Gets the user corresponding to the specified phone number.
        #
        # @param [String] phone_number
        #   A phone number, in international E.164 format.
        def get_user_by_phone_number(phone_number)
          get_user_by(phone_number: phone_number)
        end

        # Deletes the user corresponding to the specified user id.
        #
        # @param [String] uid
        #   The id of the user.
        def delete_user(uid)
          NotImplementedError
        end

        # Verifies the signature and data for the provided JWT.
        #
        # Accepts a signed token string, verifies that it is current, was issued to this project, and that
        # it was correctly signed by Google.
        #
        # @param [String] token
        #   A string of the encoded JWT.
        # @param [Boolean] check_revoked Boolean
        #   If true, checks whether the token has been revoked (optional).
        # @return [Hash]
        #   A hash of key-value pairs parsed from the decoded JWT.
        def verify_id_token(token, check_revoked = false)
          verified_claims = @id_token_verifier.verify(token)
          id_token_revoked?(verified_claims) if check_revoked
          verified_claims
        end

        private

        # Gets the user corresponding to the provided key
        def get_user_by(options)
          if (uid = options[:uid])
            payload = {localId: validate_uid(uid, required: true)}
          elsif (email = options[:email])
            payload = {email: validate_email(email, required: true)}
          elsif (phone_number = options[:phone_number])
            payload = {phoneNumber: validate_phone_number(phone_number, required: true)}
          else
            raise ArgumentError, "Unsupported options: #{options}"
          end
          res = request(:post, "#{@base_path}/accounts:lookup", payload)
          users = res&.fetch(:users)
          UserRecord.new(users.first) if users.is_a?(Array) && users.length > 0
        end

        def id_token_revoked?(claims)
          raise NotImplementedError
        end
      end
    end
  end
end
