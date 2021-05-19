require_relative "../../../spec_helper"

CERTIFICATE_URL = "https://example.com/certificates"

describe Firebase::Admin::Auth::CertificatesFetcher do
  include ActiveSupport::Testing::TimeHelpers

  describe "#fetch_certificates!" do
    let(:fetcher) { Firebase::Admin::Auth::CertificatesFetcher.new(CERTIFICATE_URL) }
    let(:certificates) { fixture("auth/certificates.json").read }

    before do
      @stub = stub_request(:get, CERTIFICATE_URL)
        .to_return(
          status: 200,
          body: certificates,
          headers: {
            "cache-control": "public, max-age=600, must-revalidate, no-transform",
            "content-type": "application/json; charset=utf-8"
          }
        )
    end

    context "when no certificates are cached" do
      it "should request them" do
        keys = fetcher.fetch_certificates!
        expect(keys).to eq(JSON.parse(certificates))
        expect(@stub).to have_been_requested
      end
    end

    context "when the cache has not expired" do
      it "should return the cached certificates" do
        certs = JSON.parse(certificates)
        expect(fetcher.fetch_certificates!).to eq(certs)
        expect(fetcher.fetch_certificates!).to eq(certs)
        expect(@stub).to have_been_requested.times(1)
      end
    end

    context "when the cache has expired" do
      it "should request them" do
        certs = JSON.parse(certificates)
        expect(fetcher.fetch_certificates!).to eq(certs)
        travel 15.minutes do
          expect(fetcher.fetch_certificates!).to eq(certs)
        end
        expect(@stub).to have_been_requested.times(2)
      end
    end
  end
end
