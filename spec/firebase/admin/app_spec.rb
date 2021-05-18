require_relative "../../spec_helper"

describe Firebase::Admin::App do
  it "should initialize with the config's project id if present" do
    config = Firebase::Admin::Config.from_file(fixture("config.json"))
    creds = Firebase::Admin::Credentials.from_file(fixture("credentials.json"))
    app = Firebase::Admin::App.new(credentials: creds, config: config)
    expect(app.credentials.credentials).to be_a(Google::Auth::ServiceAccountCredentials)
    expect(app.project_id).to eq(config.project_id)
    expect(app.service_account_id).to eq(config.service_account_id)
  end

  it "should initialize with the credential's project id if not present in the config" do
    creds = Firebase::Admin::Credentials.from_file(fixture("credentials.json"))
    app = Firebase::Admin::App.new(credentials: creds)
    expect(app.credentials.credentials).to be_a(Google::Auth::ServiceAccountCredentials)
    expect(app.project_id).to eq(creds.project_id)
    expect(app.service_account_id).to be_nil
  end

  it "should return an auth and cache it for future use" do
    creds = Firebase::Admin::Credentials.from_file(fixture("credentials.json"))
    app = Firebase::Admin::App.new(credentials: creds)
    auth = app.auth
    expect(auth).to be_a(Firebase::Admin::Auth::Client)
    expect(app.auth).to equal(auth)
  end
end
