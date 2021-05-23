module Firebase
  module Admin
    module Auth
      # A client for communicating with the Firebase Auth service.
      class Client
        # Constructs a new client
        #
        # @param [Firebase::Admin::App] app The app the client is configured with.
        def initialize(app)
          @project_id = app.project_id
          @service_account_id = app.service_account_id
          @credentials = app.credentials

          @emulated = Utils.is_emulated?
          v1_url_override = Utils.get_emulator_v1_url
          @credentials = EmulatorCredentials.new if @emulated

          @id_token_verifier = IDTokenVerifier.new(app)
          @user_manager = UserManager.new(@project_id, @credentials, v1_url_override)
        end

        # Checks if the auth client is configured to use the Firebase Auth Emulator.
        # @ return [Boolean] true if configured for the auth emulator, false otherwise.
        def emulated?
          @emulated
        end

        # Creates a new user account with the specified properties.
        #
        # @param [String, nil] uid The id to assign to the newly created user.
        # @param [String, nil] display_name The user’s display name.
        # @param [String, nil] email The user’s primary email.
        # @param [Boolean, nil] email_verified A boolean indicating whether or not the user’s primary email is verified.
        # @param [String, nil] phone_number The user’s primary phone number.
        # @param [String, nil] photo_url The user’s photo URL.
        # @param [String, nil] password The user’s raw, unhashed password.
        # @param [Boolean, nil] disabled A boolean indicating whether or not the user account is disabled.
        #
        # @raise [CreateUserError] if a user cannot be created.
        #
        # @return [UserRecord]
        def create_user(uid: nil, display_name: nil, email: nil, email_verified: nil, phone_number: nil, photo_url: nil, password: nil, disabled: nil)
          @user_manager.create_user(
            uid: uid,
            display_name: display_name,
            email: email,
            email_verified: email_verified,
            phone_number: phone_number,
            photo_url: photo_url,
            password: password,
            disabled: disabled
          )
        end

        # Gets the user corresponding to the specified user id.
        #
        # @param [String] uid
        #   The id of the user.
        #
        # @return [UserRecord]
        def get_user(uid)
          @user_manager.get_user_by(uid: uid)
        end

        # Gets the user corresponding to the specified email address.
        #
        # @param [String] email
        #   An email address.
        #
        # @return [UserRecord]
        def get_user_by_email(email)
          @user_manager.get_user_by(email: email)
        end

        # Gets the user corresponding to the specified phone number.
        #
        # @param [String] phone_number A phone number, in international E.164 format.
        def get_user_by_phone_number(phone_number)
          @user_manager.get_user_by(phone_number: phone_number)
        end

        # Deletes the user corresponding to the specified user id.
        #
        # @param [String] uid
        #   The id of the user.
        def delete_user(uid)
          @user_manager.delete_user(uid)
        end

        # Verifies the signature and data for the provided JWT.
        #
        # Accepts a signed token string, verifies that it is current, was issued to this project, and that
        # it was correctly signed by Google.
        #
        # @param [String] token A string of the encoded JWT.
        # @param [Boolean] check_revoked (false) If true, checks whether the token has been revoked.
        # @return [Hash] A hash of key-value pairs parsed from the decoded JWT.
        def verify_id_token(token, check_revoked = false)
          verified_claims = @id_token_verifier.verify(token, is_emulator: emulated?)
          revoked = check_revoked && !id_token_revoked?(verified_claims)
          verified_claims unless revoked
        end

        private

        # Checks if an ID token has been revoked.
        #
        # @param [Hash] claims The verified claims needed to perform the check.
        # @return [Boolean] true if the id token has been revoked, false otherwise.
        def id_token_revoked?(claims)
          raise NotImplementedError
        end
      end
    end
  end
end
