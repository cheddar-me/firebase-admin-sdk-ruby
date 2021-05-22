module Helpers
  module Auth
    def create_app_config
      Firebase::Admin::Config.new(project_id: "test-adminsdk-project", service_account_id: "test-service-account-id")
    end

    def create_app_credentials
      FakeCredentials.new
    end

    def with_emulator
      yield if block_given?
    ensure
      delete_accounts
    end

    def sign_in_with_email_password(email:, password:)
      client = Firebase::Admin::Internal::HTTPClient.new(uri: emulator_toolkit_uri)
      client.post("v1/accounts:signInWithPassword?key=fakeapikey", {
        email: email,
        password: password,
        returnSecureToken: true
      }).body
    end

    def delete_accounts
      client = Firebase::Admin::Internal::HTTPClient.new(uri: emulator_admin_uri)
      client.delete("v1/projects/test-adminsdk-project/accounts", nil, "Content-Type": nil)
    end

    def emulator_host
      ENV["FIREBASE_AUTH_EMULATOR_HOST"]
    end

    def emulator_admin_uri
      "http://#{emulator_host}/emulator/"
    end

    def emulator_toolkit_uri
      "http://#{emulator_host}/identitytoolkit.googleapis.com/"
    end

    class FakeCredentials
      def project_id
        "test-adminsdk-project"
      end

      def apply!(hash, opts = {})
        # don't apply any credentials here.
        # the sdk should automatically set the authorization header when using the emulator
      end
    end
  end
end
