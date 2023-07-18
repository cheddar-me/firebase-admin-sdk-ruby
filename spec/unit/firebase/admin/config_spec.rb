require_relative "../../spec_helper"

describe Firebase::Admin::Config do
  it "should load from a file path" do
    config = Firebase::Admin::Config.from_file(fixture("config.json").path)
    expect(config.project_id).to eq("test-adminsdk-project-config")
  end

  it "should load from a file using the FIREBASE_CONFIG env" do
    ClimateControl.modify(FIREBASE_CONFIG: fixture("config.json").path) do
      config = Firebase::Admin::Config.from_env
      expect(config.project_id).to eq("test-adminsdk-project-config")
    end
  end

  it "should load from JSON using the FIREBASE_CONFIG env" do
    ClimateControl.modify(FIREBASE_CONFIG: fixture("config.json").read) do
      config = Firebase::Admin::Config.from_env
      expect(config.project_id).to eq("test-adminsdk-project-config")
    end
  end
end
