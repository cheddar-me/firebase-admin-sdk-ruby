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
end
