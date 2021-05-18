require_relative "../../spec_helper"

describe Google::Auth::GCECredentials do
  include FakeFS::SpecHelpers

  context "when on gce" do
    before do
      stub_request(:get, Google::Auth::GCECredentials.compute_check_uri)
        .to_return({headers: {"Metadata-Flavor": "Google"}})
      stub_request(:get, Firebase::Admin::GCE::PROJECT_ID_URI)
        .to_return({headers: {"Metadata-Flavor": "Google"}, body: "test-adminsdk-project"})
    end

    let(:creds) { Google::Auth.get_application_default }

    it "should be able to figure out the compute engine project id" do
      expect(creds).to be_a(Google::Auth::GCECredentials)
      expect(creds.project_id).to eq("test-adminsdk-project")
    end
  end
end
