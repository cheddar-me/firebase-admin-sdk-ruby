require_relative "../../../spec_helper"

describe Firebase::Admin::Messaging::MessageEncoder do
  describe "#encode" do
    let(:encoder) { Firebase::Admin::Messaging::MessageEncoder.new }

    it "encodes an empty Message" do
      m = Firebase::Admin::Messaging::Message.new(token: "token")
      expect(encoder.encode(m)).to eq({token: "token"})
      m = Firebase::Admin::Messaging::Message.new(topic: "/topics/test")
      expect(encoder.encode(m)).to eq({topic: "test"})
      m = Firebase::Admin::Messaging::Message.new(condition: "test")
      expect(encoder.encode(m)).to eq({condition: "test"})
    end

    it "encodes a Message with an AndroidConfig" do
      m = Firebase::Admin::Messaging::Message.new(android: android, token: "test")
      exp = {android: encoded_android, token: "test"}
      expect(encoder.encode(m)).to eq(exp)
    end

    it "encodes a Message with an APNSConfig" do
      m = Firebase::Admin::Messaging::Message.new(apns: apns, token: "test")
      exp = {apns: encoded_apns, token: "test"}
      expect(encoder.encode(m)).to eq(exp)
    end

    it "encodes a Message with a Notification" do
      m = Firebase::Admin::Messaging::Message.new(notification: notification, token: "test")
      exp = {notification: encoded_notification, token: "test"}
      expect(encoder.encode(m)).to eq(exp)
    end

    it "raises an ArgumentError unless exactly one token, topic or condition is specified" do
      m = Firebase::Admin::Messaging::Message.new
      expect { encoder.encode(m) }.to raise_error(Firebase::Admin::ArgumentError)
      m.token = "token"
      m.topic = "/topics/topic"
      expect { encoder.encode(m) }.to raise_error(Firebase::Admin::ArgumentError)
    end

    let(:android_notification) {
      Firebase::Admin::Messaging::AndroidNotification.new(
        title: "title",
        body: "body",
        icon: "icon",
        color: "#001122",
        sound: "sound",
        tag: "tag",
        image: "image",
        click_action: "click_action",
        body_loc_key: "body_loc_key",
        body_loc_args: ["body_loc_args"],
        title_loc_key: "title_loc_key",
        title_loc_args: ["title_loc_args"],
        channel_id: "channel_id",
        ticker: "ticker",
        sticky: true,
        event_time: current_time,
        local_only: true,
        priority: "min",
        vibrate_timings: [0.25, 0.25],
        default_vibrate_timings: true,
        default_sound: true,
        light_settings: light_settings,
        default_light_settings: true,
        visibility: "secret",
        notification_count: 5
      )
    }

    let(:encoded_android_notification) {
      {
        title: "title",
        body: "body",
        icon: "icon",
        color: "#001122",
        sound: "sound",
        tag: "tag",
        image: "image",
        click_action: "click_action",
        body_loc_key: "body_loc_key",
        body_loc_args: ["body_loc_args"],
        title_loc_key: "title_loc_key",
        title_loc_args: ["title_loc_args"],
        channel_id: "channel_id",
        ticker: "ticker",
        sticky: true,
        event_time: current_time.dup.utc.strftime("%Y-%m-%dT%H:%M:%S.%6NZ"),
        local_only: true,
        notification_priority: "PRIORITY_MIN",
        vibrate_timings: %w[0.250000000s 0.250000000s],
        default_vibrate_timings: true,
        default_sound: true,
        light_settings: encoded_light_settings,
        default_light_settings: true,
        visibility: "SECRET",
        notification_count: 5
      }
    }

    let(:light_settings) {
      Firebase::Admin::Messaging::LightSettings.new(
        color: "#331122ff",
        light_on_duration: 0.1,
        light_off_duration: 0.1
      )
    }

    let(:encoded_light_settings) {
      {
        color: {
          red: 0x33 / 255.0,
          green: 0x11 / 255.0,
          blue: 0x22 / 255.0,
          alpha: 0xFF / 255.0
        },
        light_on_duration: "0.100000000s",
        light_off_duration: "0.100000000s"
      }
    }

    let(:android_fcm_options) {
      Firebase::Admin::Messaging::AndroidFCMOptions.new(analytics_label: "android_analytics_label")
    }

    let(:encoded_android_fcm_options) {
      {
        analytics_label: "android_analytics_label"
      }
    }

    let(:android) {
      Firebase::Admin::Messaging::AndroidConfig.new(
        collapse_key: "collapse_key",
        priority: "high",
        ttl: 1.5,
        restricted_package_name: "test_package_name",
        data: {foo: "bar"},
        notification: android_notification,
        fcm_options: android_fcm_options
      )
    }

    let(:encoded_android) {
      {
        collapse_key: "collapse_key",
        priority: "high",
        ttl: "1.500000000s",
        restricted_package_name: "test_package_name",
        data: {foo: "bar"},
        notification: encoded_android_notification,
        fcm_options: encoded_android_fcm_options
      }
    }

    let(:current_time) {
      Time.now
    }

    let(:apns) {
      Firebase::Admin::Messaging::APNSConfig.new(
        headers: {"apns-priority": "10"},
        payload: apns_payload,
        fcm_options: apns_fcm_options
      )
    }

    let(:encoded_apns) {
      {
        headers: {"apns-priority": "10"},
        payload: encoded_apns_payload,
        fcm_options: encoded_apns_fcm_options
      }
    }

    let(:apns_payload) {
      Firebase::Admin::Messaging::APNSPayload.new(
        aps: aps,
        data: {
          foo: "bar"
        }
      )
    }

    let(:encoded_apns_payload) {
      {
        aps: encoded_aps,
        foo: "bar"
      }
    }

    let(:aps) {
      Firebase::Admin::Messaging::APS.new(
        alert: aps_alert,
        badge: 5,
        sound: critical_sound,
        content_available: true,
        mutable_content: true,
        thread_id: "thread-id",
        category: "test-category",
        custom_data: {
          bar: "baz"
        }
      )
    }

    let(:encoded_aps) {
      {
        alert: encoded_aps_alert,
        badge: 5,
        sound: encoded_critical_sound,
        "content-available": 1,
        "mutable-content": 1,
        "thread-id": "thread-id",
        category: "test-category",
        bar: "baz"
      }
    }

    let(:aps_alert) {
      Firebase::Admin::Messaging::APSAlert.new(
        title: "title",
        subtitle: "subtitle",
        body: "body",
        loc_key: "loc-key",
        loc_args: ["loc-args"],
        title_loc_key: "title-loc-key",
        title_loc_args: ["title-loc-args"],
        subtitle_loc_key: "subtitle-loc-key",
        subtitle_loc_args: ["subtitle-loc-args"],
        action_loc_key: "action-loc-key",
        launch_image: "launch-image",
        custom_data: {
          foo: "bar"
        }
      )
    }

    let(:encoded_aps_alert) {
      {
        title: "title",
        subtitle: "subtitle",
        body: "body",
        "loc-key": "loc-key",
        "loc-args": ["loc-args"],
        "title-loc-key": "title-loc-key",
        "title-loc-args": ["title-loc-args"],
        "subtitle-loc-key": "subtitle-loc-key",
        "subtitle-loc-args": ["subtitle-loc-args"],
        "action-loc-key": "action-loc-key",
        "launch-image": "launch-image",
        foo: "bar"
      }
    }

    let(:critical_sound) {
      Firebase::Admin::Messaging::CriticalSound.new(
        name: "sound",
        critical: true,
        volume: 0.75
      )
    }

    let(:encoded_critical_sound) {
      {
        name: "sound",
        volume: 0.75,
        critical: 1
      }
    }

    let(:apns_fcm_options) {
      Firebase::Admin::Messaging::APNSFCMOptions.new(
        analytics_label: "analytics-label",
        image: "image"
      )
    }

    let(:encoded_apns_fcm_options) {
      {
        analytics_label: "analytics-label",
        image: "image"
      }
    }

    let(:notification) {
      Firebase::Admin::Messaging::Notification.new(
        title: "title",
        body: "body",
        image: "image"
      )
    }

    let(:encoded_notification) {
      {
        title: "title",
        body: "body",
        image: "image"
      }
    }
  end
end
