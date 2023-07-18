require_relative "../../spec_helper"

describe Firebase::Admin::Config do
  include FakeFS::SpecHelpers

  let(:config_file) { fixture("config.json") }

  it "should load from a file path" do
    config = Firebase::Admin::Config.from_file(config_file.path)
    expect(config.project_id).to eq("test-adminsdk-project-config")
  end

  it "should load from a file using the FIREBASE_CONFIG env" do
    ClimateControl.modify(FIREBASE_CONFIG: config_file.path) do
      config = Firebase::Admin::Config.from_env
      expect(config.project_id).to eq("test-adminsdk-project-config")
    end
  end

  it "should load from JSON using the FIREBASE_CONFIG env" do
    ClimateControl.modify(FIREBASE_CONFIG: config_file.read) do
      config = Firebase::Admin::Config.from_env
      expect(config.project_id).to eq("test-adminsdk-project-config")
    end
  end
end
