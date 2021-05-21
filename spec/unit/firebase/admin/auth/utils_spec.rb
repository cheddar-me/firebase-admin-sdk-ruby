require_relative "../../../spec_helper"

describe Firebase::Admin::Auth::Utils do
  include Firebase::Admin::Auth::Utils

  describe "#validate_uid" do
    it "should return the value if the argument is valid" do
      expect(validate_uid("1234", required: false)).to eq("1234")
      expect(validate_uid("1234", required: true)).to eq("1234")
      expect(validate_uid("0" * 128, required: false)).to eq("0" * 128)
      expect(validate_uid("0" * 128, required: true)).to eq("0" * 128)
    end

    it "should return nil if the argument is nil and not required" do
      expect(validate_uid(nil, required: false)).to be_nil
    end

    it "should raise an error if a value is nil and required" do
      expect { validate_uid(nil, required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end

    it "should raise an error if an invalid value is supplied" do
      expect { validate_uid("", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_uid("", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_uid("0" * 129, required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_uid("0" * 129, required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#validate_email" do
    it "should return the value if the argument is valid" do
      expect(validate_email("test@example.com", required: false)).to eq("test@example.com")
      expect(validate_email("test@example.com", required: true)).to eq("test@example.com")
    end

    it "should return nil if the argument is nil and not required" do
      expect(validate_email(nil, required: false)).to be_nil
    end

    it "should raise an error if a value is nil and required" do
      expect { validate_email(nil, required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end

    it "should raise an error if an invalid value is supplied" do
      expect { validate_email("", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_email("", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_email("test", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_email("test", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#validate_phone_number" do
    it "should return the value if the argument is valid" do
      expect(validate_phone_number("+15105551234", required: false)).to eq("+15105551234")
      expect(validate_phone_number("+15105551234", required: true)).to eq("+15105551234")
    end

    it "should return nil if the argument is nil and not required" do
      expect(validate_phone_number(nil, required: false)).to be_nil
    end

    it "should raise an error if a value is nil and required" do
      expect { validate_phone_number(nil, required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end

    it "should raise an error if an invalid value is supplied" do
      expect { validate_phone_number("", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_phone_number("", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_phone_number("5105551234", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_phone_number("5105551234", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#validate_password" do
    it "should return the value if the argument is valid" do
      expect(validate_password("123456", required: false)).to eq("123456")
      expect(validate_password("123456", required: true)).to eq("123456")
    end

    it "should return nil if the argument is nil and not required" do
      expect(validate_password(nil, required: false)).to be_nil
    end

    it "should raise an error if a value is nil and required" do
      expect { validate_password(nil, required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end

    it "should raise an error if an invalid value is supplied" do
      expect { validate_password("", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_password("", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_password("12345", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_password("12345", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#validate_password" do
    it "should return the value if the argument is valid" do
      expect(validate_password("123456", required: false)).to eq("123456")
      expect(validate_password("123456", required: true)).to eq("123456")
    end

    it "should return nil if the argument is nil and not required" do
      expect(validate_password(nil, required: false)).to be_nil
    end

    it "should raise an error if a value is nil and required" do
      expect { validate_password(nil, required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end

    it "should raise an error if an invalid value is supplied" do
      expect { validate_password("", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_password("", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_password("12345", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_password("12345", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#validate_photo_url" do
    it "should return the value if the argument is valid" do
      expect(validate_photo_url("https://images.test.com/123", required: false)).to eq("https://images.test.com/123")
      expect(validate_photo_url("https://images.test.com/123", required: true)).to eq("https://images.test.com/123")
    end

    it "should return nil if the argument is nil and not required" do
      expect(validate_photo_url(nil, required: false)).to be_nil
    end

    it "should raise an error if a value is nil and required" do
      expect { validate_photo_url(nil, required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end

    it "should raise an error if an invalid value is supplied" do
      expect { validate_photo_url("", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_photo_url("", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#validate_display_name" do
    it "should return the value if the argument is valid" do
      expect(validate_display_name("display name", required: false)).to eq("display name")
      expect(validate_display_name("display name", required: true)).to eq("display name")
    end

    it "should return nil if the argument is nil and not required" do
      expect(validate_display_name(nil, required: false)).to be_nil
    end

    it "should raise an error if a value is nil and required" do
      expect { validate_display_name(nil, required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end

    it "should raise an error if an invalid value is supplied" do
      expect { validate_display_name("", required: false) }.to raise_error(Firebase::Admin::ArgumentError)
      expect { validate_display_name("", required: true) }.to raise_error(Firebase::Admin::ArgumentError)
    end
  end

  describe "#to_boolean" do
    it "should return true if the value is true" do
      expect(to_boolean(true)).to eq(true)
    end

    it "should return false if the value is false" do
      expect(to_boolean(false)).to eq(false)
    end

    it "should return nil if the value is nil" do
      expect(to_boolean(nil)).to be_nil
    end
  end

  describe "#is_emulated?" do
    context "when FIREBASE_AUTH_EMULATOR_HOST is set" do
      it "should return true if the value is valid" do
        ClimateControl.modify(FIREBASE_AUTH_EMULATOR_HOST: "localhost:9099") do
          expect(is_emulated?).to be_truthy
        end
      end

      it "should raise an ArgumentError if the value contains //" do
        ClimateControl.modify(FIREBASE_AUTH_EMULATOR_HOST: "http://localhost:9099") do
          expect { is_emulated? }.to raise_error(Firebase::Admin::ArgumentError)
        end
      end
    end
  end

  describe "#get_emulator_host" do
    context "when FIREBASE_AUTH_EMULATOR_HOST is set" do
      it "should return the value" do
        ClimateControl.modify(FIREBASE_AUTH_EMULATOR_HOST: "localhost:9099") do
          expect(get_emulator_host).to eq("localhost:9099")
        end
      end

      it "should return nil if the value is empty" do
        ClimateControl.modify(FIREBASE_AUTH_EMULATOR_HOST: "") do
          expect(get_emulator_host).to be_nil
        end
      end

      it "should raise an ArgumentError if the value contains //" do
        ClimateControl.modify(FIREBASE_AUTH_EMULATOR_HOST: "http://localhost:9099") do
          expect { is_emulated? }.to raise_error(Firebase::Admin::ArgumentError)
        end
      end
    end

    context "when FIREBASE_AUTH_EMULATOR_HOST is not set" do
      it "should return nil" do
        expect(get_emulator_host).to be_nil
      end
    end
  end

  describe "#get_emulator_v1_url" do
    context "when FIREBASE_AUTH_EMULATOR_HOST is set" do
      it "should return the url" do
        ClimateControl.modify(FIREBASE_AUTH_EMULATOR_HOST: "localhost:9099") do
          expect(get_emulator_v1_url).to eq("http://localhost:9099/identitytoolkit.googleapis.com/v1")
        end
      end

      it "should return nil if the value is empty" do
        ClimateControl.modify(FIREBASE_AUTH_EMULATOR_HOST: "") do
          expect(get_emulator_v1_url).to be_nil
        end
      end

      it "should raise an ArgumentError if the value contains //" do
        ClimateControl.modify(FIREBASE_AUTH_EMULATOR_HOST: "http://localhost:9099") do
          expect { get_emulator_v1_url }.to raise_error(Firebase::Admin::ArgumentError)
        end
      end
    end

    context "when FIREBASE_AUTH_EMULATOR_HOST is not set" do
      it "should return nil" do
        expect(get_emulator_v1_url).to be_nil
      end
    end
  end
end
