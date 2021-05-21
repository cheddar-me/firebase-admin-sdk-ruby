require_relative "../../../spec_helper"

describe Firebase::Admin::Auth::IDTokenVerifier do
  include ActiveSupport::Testing::TimeHelpers
  include JWTHelper

  let(:creds) { Firebase::Admin::Credentials.from_file(fixture("credentials.json")) }
  let(:app) { Firebase::Admin::App.new(credentials: creds) }
  let(:id_token_verifier) { Firebase::Admin::Auth::IDTokenVerifier.new(app) }
  let(:cert_uri) { Firebase::Admin::Auth::IDTokenVerifier::CERTIFICATES_URI }

  describe "#verify" do
    context "when the jwt is valid" do
      it "should return the payload" do
        key, cert = create_certificate
        stub = stub_certificate_request({"12345" => cert}, cert_uri)
        jwt = encode_jwt("RS256", "12345", key)
        decoded_token = id_token_verifier.verify(jwt)
        expect(decoded_token).to be_a(Hash)
        expect(decoded_token).to include("uid" => "12345")
        expect(stub).to have_been_requested
      end
    end

    context "when the jwt is invalid" do
      it "should raise an InvalidTokenError if the subject claim is missing" do
        key, cert = create_certificate
        stub = stub_certificate_request({"12345" => cert}, cert_uri)
        jwt = encode_jwt("RS256", "12345", key, sub: nil)
        expect { id_token_verifier.verify(jwt) }.to raise_error(Firebase::Admin::Auth::InvalidTokenError)
        expect(stub).to have_been_requested
      end

      it "should raise an InvalidTokenError if the subject claim is empty" do
        key, cert = create_certificate
        stub = stub_certificate_request({"12345" => cert}, cert_uri)
        jwt = encode_jwt("RS256", "12345", key, sub: "")
        expect { id_token_verifier.verify(jwt) }.to raise_error(Firebase::Admin::Auth::InvalidTokenError)
        expect(stub).to have_been_requested
      end

      it "should raise an InvalidTokenError if the issuer claim is incorrect" do
        key, cert = create_certificate
        stub = stub_certificate_request({"12345" => cert}, cert_uri)
        jwt = encode_jwt("RS256", "12345", key, iss: "https://securetoken.google.com/wrong-project")
        expect { id_token_verifier.verify(jwt) }.to raise_error(Firebase::Admin::Auth::InvalidTokenError)
        expect(stub).to have_been_requested
      end

      it "should raise an InvalidTokenError if the audience claim is incorrect" do
        key, cert = create_certificate
        stub = stub_certificate_request({"12345" => cert}, cert_uri)
        jwt = encode_jwt("RS256", "12345", key, aud: "wrong-project")
        expect { id_token_verifier.verify(jwt) }.to raise_error(Firebase::Admin::Auth::InvalidTokenError)
        expect(stub).to have_been_requested
      end
    end

    context "when the jwt is expired" do
      it "should raise an ExpiredTokenError" do
        key, cert = create_certificate
        stub = stub_certificate_request({"12345" => cert}, cert_uri)
        jwt = encode_jwt("RS256", "12345", key, iss: "https://securetoken.google.com/wrong-project")
        travel 20.minutes do
          expect { id_token_verifier.verify(jwt) }.to raise_error(Firebase::Admin::Auth::ExpiredTokenError)
        end
        expect(stub).to have_been_requested
      end
    end

    context "when the public key certificate is not found" do
      it "should raise an InvalidTokenError" do
        key, cert = create_certificate
        stub = stub_certificate_request({"12345" => cert}, cert_uri)
        jwt = encode_jwt("RS256", "67890", key)
        expect { id_token_verifier.verify(jwt) }.to raise_error(Firebase::Admin::Auth::InvalidTokenError)
        expect(stub).to have_been_requested
      end
    end

    context "when the public key certificates fail to fetch" do
      it "should raise an InvalidTokenError" do
        key, _ = create_certificate
        stub_request(:get, cert_uri).to_return(status: 404)
        jwt = encode_jwt("RS256", "12345", key)
        expect { id_token_verifier.verify(jwt) }.to raise_error(Firebase::Admin::Auth::CertificateRequestError)
      end
    end
  end
end
