require_relative "../../../spec_helper"

describe Firebase::Admin::FCM::Client do
  include FCMHelper

  before do
    creds = FakeCredentials.from_file(fixture("credentials.json"))
    @app = Firebase::Admin::App.new(credentials: creds)
  end

  let(:message) {
    Firebase::Admin::FCM::Message.new(
      token: "fake-fcm-token",
      notification: Firebase::Admin::FCM::Notification.new(
        title: "test",
        body: "this is a test"
      )
    )
  }

  describe "#send_one" do
    context "when the message is valid" do
      before do
        stub_send_request("fcm/send_one.json")
      end

      it "should return a unique message id" do
        result = @app.fcm.send_one(message)
        expect(result).to eq("projects/test-adminsdk-project/messages/fake_message_id")
      end
    end

    context "when the token is unregistered" do
      before do
        stub_send_request("fcm/unregistered_error.json", {status: 404})
      end

      it "should raise an UnregisteredError" do
        expect { @app.fcm.send_one(message) }.to raise_error(Firebase::Admin::FCM::UnregisteredError) { |e|
          expect(e.info).to eq(
            {
              "code" => 404,
              "message" => "Requested entity was not found.",
              "status" => "NOT_FOUND",
              "details" => [
                {
                  "@type" => "type.googleapis.com/google.firebase.fcm.v1.FcmError",
                  "errorCode" => "UNREGISTERED"
                }
              ]
            }
          )
        }
      end
    end

    context "when the token is invalid" do
      before do
        stub_send_request("fcm/invalid_argument_error.json", {status: 400})
      end

      it "should raise an InvalidArgumentError" do
        expect { @app.fcm.send_one(message) }.to raise_error(Firebase::Admin::FCM::InvalidArgumentError) { |e|
          expect(e.info).to eq(
            {
              "code" => 400,
              "message" => "The registration token is not a valid FCM registration token",
              "status" => "INVALID_ARGUMENT",
              "details" => [
                {
                  "@type" => "type.googleapis.com/google.firebase.fcm.v1.FcmError",
                  "errorCode" => "INVALID_ARGUMENT"
                }
              ]
            }
          )
        }
      end
    end

    context "when a quota limit is exceeded" do
      before do
        stub_send_request("fcm/quota_exceeded_error.json", {status: 429})
      end

      it "should raise an QuotaExceededError" do
        expect { @app.fcm.send_one(message) }.to raise_error(Firebase::Admin::FCM::QuotaExceededError) { |e|
          expect(e.info).to eq(
            {
              "code" => 429,
              "message" => "Message rate exceeded",
              "status" => "RESOURCE_EXHAUSTED",
              "details" => [
                {
                  "@type" => "type.googleapis.com/google.firebase.fcm.v1.FcmError",
                  "errorCode" => "QUOTA_EXCEEDED"
                },
                {
                  "@type" => "type.googleapis.com/google.rpc.QuotaFailure",
                  "violations" => [
                    {
                      "subject" => "project:test-adminsdk-project",
                      "description" => "Message rate exceeded"
                    }
                  ]
                }
              ]
            }
          )
        }
      end
    end

    context "when the sender id is incorrect" do
      before do
        stub_send_request("fcm/sender_id_mismatch.json", {status: 403})
      end

      it "should raise a SenderIdMismatchError" do
        expect { @app.fcm.send_one(message) }.to raise_error(Firebase::Admin::FCM::SenderIdMismatchError) { |e|
          expect(e.info).to eq(
            {
              "code" => 403,
              "message" => "SenderId mismatch",
              "status" => "PERMISSION_DENIED",
              "details" => [
                {
                  "@type" => "type.googleapis.com/google.firebase.fcm.v1.FcmError",
                  "errorCode" => "SENDER_ID_MISMATCH"
                }
              ]
            }
          )
        }
      end
    end

    context "when apns or web push certificates are invalid" do
      before do
        stub_send_request("fcm/third_party_auth_error.json", {status: 401})
      end

      it "should raise a ThirdPartyAuthError" do
        expect { @app.fcm.send_one(message) }.to raise_error(Firebase::Admin::FCM::ThirdPartyAuthError) { |e|
          expect(e.info).to eq(
            {
              "code" => 401,
              "message" => "Auth error from APNS or Web Push Service",
              "status" => "UNAUTHENTICATED",
              "details" => [
                {
                  "@type" => "type.googleapis.com/google.firebase.fcm.v1.FcmError",
                  "errorCode" => "THIRD_PARTY_AUTH_ERROR"
                },
                {
                  "@type" => "type.googleapis.com/google.firebase.fcm.v1.ApnsError",
                  "statusCode" => 403,
                  "reason" => "InvalidProviderToken"
                }
              ]
            }
          )
        }
      end
    end
  end

  describe "#subscribe_to_topic" do
    it "should return a topic management response" do
      stub_topic_request("batchAdd", "fcm/subscribe.json")
      tokens = %w[token not-found-token]
      response = @app.fcm.subscribe_to_topic(tokens, "test-topic")
      expect(response).to be_a(Firebase::Admin::FCM::TopicManagementResponse)
      expect(response.success_count).to eq(1)
      expect(response.errors.length).to eq(1)
      expect(response.errors[0].index).to eq(1)
      expect(response.errors[0].reason).to eq("NOT_FOUND")
    end
  end

  describe "#unsubscribe_from_topic" do
    it "should return a topic management response" do
      stub_topic_request("batchRemove", "fcm/subscribe.json")
      tokens = %w[token not-found-token]
      response = @app.fcm.unsubscribe_from_topic(tokens, "test-topic")
      expect(response).to be_a(Firebase::Admin::FCM::TopicManagementResponse)
      expect(response.success_count).to eq(1)
      expect(response.errors.length).to eq(1)
      expect(response.errors[0].index).to eq(1)
      expect(response.errors[0].reason).to eq("NOT_FOUND")
    end
  end
end
