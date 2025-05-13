require_relative "../../../spec_helper"

describe Firebase::Admin::Auth::Client do
  include AuthHelper

  before do
    creds = FakeCredentials.from_file(fixture("credentials.json"))
    @app = Firebase::Admin::App.new(credentials: creds)
  end

  describe "#create_user" do
    context "with a phone number" do
      before do
        stub_auth_request(:post, "/accounts")
          .to_return({body: fixture("auth/create_user.json"), headers: {content_type: "application/json; charset=utf-8"}})
        stub_auth_request(:post, "/accounts:lookup")
          .to_return({body: fixture("auth/get_user.json"), headers: {content_type: "application/json; charset=utf-8"}})
      end

      it "creates a user" do
        user = @app.auth.create_user(phone_number: "+15005550100")
        expect(user).to be_a(Firebase::Admin::Auth::UserRecord)
        expect(user.phone_number).to eq("+15005550100")
        expect(user.uid).to_not be_nil
      end
    end
  end

  describe "#create_session_cookie" do
    before do
      stub_auth_request(:post, "/createSessionCookie")
        .to_return({body: "sessioncookiecontents", headers: {content_type: "application/json; charset=utf-8"}})
    end

    it "creates a cookie" do
      session_cookie = @app.auth.create_session_cookie('idtoken')
      expect(session_cookie["idToken"])
      expect(session_cookie["validDuration"])
    end
  end

  describe "#set_custom_user_claims" do
    let(:uid) { "test-uid" }
    let(:claims) { {admin: true} }

    context "when setting custom claims" do
      before do
        stub_auth_request(:post, "/accounts:update")
          .with(body: hash_including({localId: uid, customAttributes: claims.to_json}))
          .to_return({body: {localId: uid}.to_json, headers: {content_type: "application/json; charset=utf-8"}})
        stub_auth_request(:post, "/accounts:lookup")
          .to_return({body: {users: [{localId: uid, customAttributes: {admin: true}.to_json}]}.to_json, headers: {content_type: "application/json; charset=utf-8"}})
      end

      it "sets custom claims for the user and returns the user record" do
        user = @app.auth.set_custom_user_claims(uid, claims)
        expect(user).to be_a(Firebase::Admin::Auth::UserRecord)
        expect(user.uid).to eq(uid)
        expect(user.custom_claims["admin"]).to eq(true)
      end
    end

    context "when removing all custom claims" do
      before do
        stub_auth_request(:post, "/accounts:update")
          .with(body: hash_including({localId: uid, customAttributes: nil}))
          .to_return({body: {localId: uid}.to_json, headers: {content_type: "application/json; charset=utf-8"}})
        stub_auth_request(:post, "/accounts:lookup")
          .to_return({body: {users: [{localId: uid, customAttributes: nil}]}.to_json, headers: {content_type: "application/json; charset=utf-8"}})
      end

      it "removes all custom claims for the user" do
        user = @app.auth.set_custom_user_claims(uid, nil)
        expect(user).to be_a(Firebase::Admin::Auth::UserRecord)
        expect(user.uid).to eq(uid)
        expect(user.custom_claims).to be_nil.or eq({})
      end
    end

    context "when the operation fails" do
      before do
        stub_auth_request(:post, "/accounts:update")
          .to_return({body: {error: "something went wrong"}.to_json, headers: {content_type: "application/json; charset=utf-8"}})
      end

      it "raises SetCustomUserClaimsError" do
        expect {
          @app.auth.set_custom_user_claims(uid, claims)
        }.to raise_error(Firebase::Admin::Auth::SetCustomUserClaimsError)
      end
    end
  end
end
