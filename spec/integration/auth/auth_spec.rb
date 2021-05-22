require_relative "../spec_helper"

describe "Firebase::Admin::Auth::Client" do
  include Helpers::Auth

  let(:app) { Firebase::Admin::App.new(credentials: create_app_credentials, config: create_app_config) }

  describe "#emulated?" do
    it "should return true" do
      expect(app.auth.emulated?).to be_truthy
    end
  end

  describe "#create_user" do
    it "should return a UserRecord" do
      with_emulator do
        user = app.auth.create_user(
          uid: "1234567890",
          display_name: "test",
          email: "test@example.com",
          email_verified: true,
          phone_number: "+15105551234",
          photo_url: "https://example.com/photo/test",
          password: "123456",
          disabled: true
        )
        expect(user).to be_a(Firebase::Admin::Auth::UserRecord)
        expect(user.uid).to eq("1234567890")
        expect(user.display_name).to eq("test")
        expect(user.email).to eq("test@example.com")
        expect(user.email_verified?).to be_truthy
        expect(user.phone_number).to eq("+15105551234")
        expect(user.photo_url).to eq("https://example.com/photo/test")
        expect(user.disabled?).to be_truthy
      end
    end
  end

  describe "#verify_id_token" do
    it "should return the verified claims" do
      with_emulator do
        user = app.auth.create_user(email: "test@example.com", password: "123456", phone_number: "+15105551234")
        token_info = sign_in_with_email_password(email: "test@example.com", password: "123456")
        expect(token_info).to be_a(Hash)
        id_token = token_info.fetch(:idToken)
        claims = app.auth.verify_id_token(id_token)
        expect(claims).to be_a(Hash)
        expect(claims["uid"]).to eq(user.uid)
      end
    end
  end
end
