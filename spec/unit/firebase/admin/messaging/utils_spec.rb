require_relative "../../../spec_helper"

describe Firebase::Admin::Messaging::Utils do
  include Firebase::Admin::Messaging::Utils

  describe "#check_string" do
    it "should return the value" do
      expect(check_string("test", "foo", non_empty: false)).to eq("foo")
      expect(check_string("test", "foo", non_empty: true)).to eq("foo")
      expect(check_string("test", "", non_empty: false)).to eq("")
      expect(check_string("test", nil, non_empty: false)).to be_nil
      expect(check_string("test", nil, non_empty: true)).to be_nil
    end

    it "should raise an ArgumentError" do
      expect { check_string("test", "", non_empty: true) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { check_string("test", 1) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#check_numeric" do
    it "should return the value" do
      expect(check_numeric("test", 0.5)).to eq(0.5)
      expect(check_numeric("test", 1)).to eq(1)
      expect(check_numeric("test", nil)).to be_nil
    end

    it "should raise an ArgumentError" do
      expect { check_numeric("test", "foo") }.to raise_error(Firebase::Admin::ArgumentError)
      expect { check_numeric("test", true) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#check_string_hash" do
    it "should return the value" do
      hash = {foo: "bar"}
      hash["bar"] = "baz"
      expect(check_string_hash("test", hash)).to eq(hash.dup)
      expect(check_string_hash("test", nil)).to be_nil
      expect(check_string_hash("test", {})).to be_nil
    end

    it "should raise an ArgumentError" do
      bad_hash = {foo: true}
      expect { check_string_hash("test", bad_hash) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { check_string_hash("test", "foo") }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#check_string_array" do
    it "should return the value" do
      expect(check_string_array("test", %w[foo bar])).to eq(%w[foo bar])
      expect(check_string_array("test", nil)).to be_nil
      expect(check_string_array("test", [])).to be_nil
    end

    it "should raise an ArgumentError" do
      expect { check_string_array("test", ["foo", :bar]) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#check_numeric_array" do
    it "should return the value" do
      expect(check_numeric_array("test", [1, 0.5])).to eq([1, 0.5])
      expect(check_numeric_array("test", nil)).to be_nil
      expect(check_numeric_array("test", [])).to be_nil
    end

    it "should raise an ArgumentError" do
      expect { check_numeric_array("test", [1, "0.5"]) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#check_analytics_label" do
    it "should return the value" do
      expect(check_analytics_label("test", nil)).to be_nil
      expect(check_analytics_label("test", "a")).to eq("a")
      expect(check_analytics_label("test", "a" * 50)).to eq("a" * 50)
      expect(check_analytics_label("test", "%test_analytics-label.20~21")).to eq("%test_analytics-label.20~21")
    end

    it "should raise an ArgumentError" do
      expect { check_analytics_label("test", "") }.to raise_error(Firebase::Admin::ArgumentError)
      expect { check_analytics_label("test", "a" * 51) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { check_analytics_label("test", "$") }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#check_time" do
    it "should return the value" do
      t = Time.now
      expect(check_time("test", nil)).to be_nil
      expect(check_time("test", t)).to eq(t)
    end

    it "should raise an ArgumentError" do
      expect { check_time("test", "foo") }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#check_color" do
    it "should return the value" do
      expect(check_color("test", nil)).to be_nil
      expect(check_color("test", "#012345", allow_alpha: false)).to eq("#012345")
      expect(check_color("test", "#6789ab", allow_alpha: true)).to eq("#6789ab")
      expect(check_color("test", "#abcdef00", allow_alpha: true)).to eq("#abcdef00")
      expect(check_color("test", "#ABCDEF00", allow_alpha: true)).to eq("#ABCDEF00")
    end

    it "should raise an ArgumentError" do
      expect { check_color("test", nil, required: true) }.to raise_error(Firebase::Admin::Error)
      expect { check_color("test", "") }.to raise_error(Firebase::Admin::Error)
      expect { check_color("test", "#001122ff", allow_alpha: false) }.to raise_error(Firebase::Admin::Error)
      expect { check_color("test", 123) }.to raise_error(Firebase::Admin::Error)
    end
  end

  describe "#to_seconds_string" do
    it "should return the value formatted as a string" do
      expect(to_seconds_string(1)).to eq("1s")
      expect(to_seconds_string(1.5)).to eq("1.500000000s")
      expect(to_seconds_string(0.123456789)).to eq("0.123456789s")
    end
  end
end
