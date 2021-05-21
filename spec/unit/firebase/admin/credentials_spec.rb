require_relative "../../spec_helper"

describe Firebase::Admin::Credentials do
  let(:creds_file) { fixture("credentials.json") }

  it "should load a service account from a file" do
    creds = Firebase::Admin::Credentials.from_file(creds_file)
    expect(creds.credentials).to be_a(Google::Auth::ServiceAccountCredentials)
    expect(creds.project_id).to eq("test-adminsdk-project")
  end

  it "should load a service account from a json string" do
    creds = Firebase::Admin::Credentials.from_json(creds_file.read)
    expect(creds.credentials).to be_a(Google::Auth::ServiceAccountCredentials)
    expect(creds.project_id).to eq("test-adminsdk-project")
  end

  context "when GOOGLE_APPLICATION_CREDENTIALS exist" do
    it "should load a service account" do
      ClimateControl.modify(Google::Auth::CredentialsLoader::ENV_VAR => creds_file.path) do
        creds = Firebase::Admin::Credentials.from_default
        expect(creds.credentials).to be_a(Google::Auth::ServiceAccountCredentials)
        expect(creds.project_id).to eq("test-adminsdk-project")
      end
    end
  end
end
