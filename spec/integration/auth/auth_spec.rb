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
        expect(user).to_not be_nil
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

  describe "#get_user_by_email" do
    context "when the email exists" do
      it "should return a UserRecord" do
        with_emulator do
          uid = app.auth.create_user(email: "test@example.com", password: "123456")&.uid
          user = app.auth.get_user_by_email("test@example.com")
          expect(user).to_not be_nil
          expect(user).to be_a(Firebase::Admin::Auth::UserRecord)
          expect(user.email).to eq("test@example.com")
          expect(user.uid).to eq(uid)
        end
      end
    end

    context "when the email does not exist" do
      it "should return nil" do
        with_emulator do
          expect(app.auth.get_user_by_email("nouser@example.com")).to be_nil
        end
      end
    end
  end

  describe "#get_user_by_phone_number" do
    context "when the phone number exists" do
      it "should return a UserRecord" do
        with_emulator do
          uid = app.auth.create_user(phone_number: "+15105551234")&.uid
          user = app.auth.get_user_by_phone_number("+15105551234")
          expect(user).to_not be_nil
          expect(user).to be_a(Firebase::Admin::Auth::UserRecord)
          expect(user.phone_number).to eq("+15105551234")
          expect(user.uid).to eq(uid)
        end
      end
    end

    context "when the phone number does not exist" do
      it "should return nil" do
        with_emulator do
          expect(app.auth.get_user_by_phone_number("+15105555678")).to be_nil
        end
      end
    end
  end

  describe "#delete_user" do
    context "when a user exists" do
      it "should delete the user" do
        with_emulator do
          user = app.auth.create_user(email: "test@example.com", password: "123456")
          expect(user).to_not be_nil
          expect(user).to be_a(Firebase::Admin::Auth::UserRecord)
          app.auth.delete_user(user.uid)
          expect(app.auth.get_user(user.uid)).to be_nil
        end
      end
    end
  end

  describe "#verify_id_token" do
    it "should return the verified claims" do
      with_emulator do
        user = app.auth.create_user(email: "test@example.com", password: "123456", phone_number: "+15105551234")
        token_info = sign_in_with_email_password(email: "test@example.com", password: "123456")
        expect(token_info).to be_a(Hash)
        id_token = token_info.fetch("idToken")
        claims = app.auth.verify_id_token(id_token)
        expect(claims).to be_a(Hash)
        expect(claims["uid"]).to eq(user.uid)
      end
    end
  end
end
