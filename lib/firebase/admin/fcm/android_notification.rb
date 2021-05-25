module Firebase
  module Admin
    module FCM
      # Android-specific notification options that can be included in an {AndroidConfig}.
      #
      # @!attribute title
      #   @return [String, nil]
      #     Title of the Android notification. When provided, overrides the title set via {Notification}.
      #
      # @!attribute body
      #   @return [String, nil]
      #     Body of the Android notification. When provided, overrides the body set via {Notification}.
      #
      # @!attribute icon
      #   @return [String, nil]
      #     Icon resource for the Android notification.
      #
      # @!attribute color
      #   @return [String, nil]
      #     Notification icon color in `#rrggbb` format.
      #
      # @!attribute sound
      #   @return [String, nil]
      #     File name of the sound to be played when the device receives the notification.
      #
      # @!attribute tag
      #   @return [String, nil]
      #     Notification tag. This is an identifier used to replace existing notifications in the notification drawer.
      #     If not specified, each request creates a new notification.
      #
      # @!attribute image_url
      #   @return [String, nil]
      #     URL of an image to be displayed in the notification.
      #
      # @!attribute click_action
      #   @return [String, nil]
      #     Action associated with a user click on the notification. If specified, an activity with a matching
      #     Intent Filter is launched when a user clicks on the notification.
      #
      # @!attribute body_loc_key
      #   @return [String, nil]
      #     Key of the body string in the app's string resource to use to localize the body text.
      #
      # @!attribute body_loc_args
      #   @return [Array<String>, nil]
      #     An array of resource keys that will be used in place of the format specifiers in {body_loc_key}.
      #
      # @!attribute title_loc_key
      #   @return [String, nil]
      #     Key of the title string in the app's string resource to use to localize the title text.
      #
      # @!attribute title_loc_args
      #   @return [Array<String>, nil]
      #     An array of resource keys that will be used in place of the format specifiers in {title_loc_key}.
      #
      # @!attribute channel_id
      #   @return [String, nil]
      #     The Android notification channel id (new in Android O). The app must create a channel with this channel id
      #     before any notification with this channel id can be received. If you don't send this channel id in the
      #     request, or if the channel id provided has not yet been created by the app, FCM uses the channel id
      #     specified in the app manifest.
      #
      # @!attribute ticker
      #   @return [String, nil]
      #     Sets the "ticker" text, which is sent to accessibility services. Prior to API level 21 (Lollipop), sets the
      #     text that is displayed in the status bar when the notification first arrives.
      #
      # @!attribute sticky
      #   @return [Boolean, nil]
      #     When set to `false` or unset, the notification is automatically dismissed when the user clicks it in the
      #     panel. When set to `true`, the notification persists even when the user clicks it.
      #
      # @!attribute event_timestamp
      #   @return [Time, nil]
      #     For notifications that inform users about events with an absolute time reference, sets the time that the
      #     event in the notification occurred. Notifications in the panel are sorted by this time.
      #
      # @!attribute local_only
      #   @return [Boolean, nil]
      #     Sets whether or not this notification is relevant only to the current device. Some notifications can be
      #     bridged to other devices for remote display, such as a Wear OS watch. This hint can be set to recommend
      #     this notification not be bridged.
      #
      # @!attribute priority
      #   @return [String, nil]
      #     Sets the relative priority for this notification. Low-priority notifications may be hidden from the user in
      #     certain situations. Note this priority differs from `AndroidMessagePriority`. This priority is processed by
      #     the client after the message has been delivered. Whereas `AndroidMessagePriority` is an FCM concept that
      #     controls when the message is delivered.
      #
      # @!attribute vibrate_timings_millis
      #   @return [Array<Integer>, nil]
      #     Sets the vibration pattern to use. Pass in an array of milliseconds to turn the vibrator on or off. The
      #     first value indicates the duration to wait before turning the vibrator on. The next value indicates the
      #     duration to keep the vibrator on. Subsequent values alternate between duration to turn the vibrator off and
      #     to turn the vibrator on. If `vibrate_timings` is set and `default_vibrate_timings` is set to `true`, the
      #     default value is used instead of the user-specified `vibrate_timings`.
      #
      # @!attribute default_vibrate_timings
      #   @return [Boolean, nil]
      #     If set to `true`, use the Android framework's default vibrate pattern for the notification. Default values
      #     are specified in `config.xml`. If `default_vibrate_timings` is set to `true` and `vibrate_timings` is also
      #     set, the default value is used instead of the user-specified `vibrate_timings`.
      #   @see https://android.googlesource.com/platform/frameworks/base/+/master/core/res/res/values/config.xml
      #
      # @!attribute default_sound
      #   @return [Boolean, nil]
      #     If set to `true`, use the Android framework's default sound for the notification. Default values are
      #     specified in `config.xml`.
      #   @see https://android.googlesource.com/platform/frameworks/base/+/master/core/res/res/values/config.xml
      #
      # @!attribute light_settings
      #   @return [LightSettings, nil]
      #     Settings to control the notification's LED blinking rate and color if LED is available on the device.
      #     The total blinking time is controlled by the OS.
      #
      # @!attribute default_light_settings
      #   @return [Boolean, nil]
      #     If set to `true`, use the Android framework's default LED light settings for the notification. Default
      #     values are specified in `config.xml`. If `default_light_settings` is set to `true` and `light_settings` is
      #     also set, the user-specified `light_settings` is used instead of the default value.
      #   @see https://android.googlesource.com/platform/frameworks/base/+/master/core/res/res/values/config.xml
      #
      # @!attribute visibility
      #   @return [String, nil]
      #     Sets the visibility of the notification. Must be either `private`, `public`, or `secret`. If unspecified,
      #     defaults to `private`.
      #
      # @!attribute notification_count
      #   @return [Integer, nil]
      #     Sets the number of items this notification represents. May be displayed as a badge count for Launchers that
      #     support badging. For example, this might be useful if you're using just one notification to represent
      #     multiple new messages but you want the count here to represent the number of total new messages. If zero
      #     or unspecified, systems that support badging use the default, which is to increment a number displayed on
      #     the long-press menu each time a new notification arrives.
      #   @see https://developer.android.com/training/notify-user/badges
      AndroidNotification = Struct.new(
        :title,
        :body,
        :icon,
        :color,
        :sound,
        :tag,
        :image_url,
        :click_action,
        :body_loc_key,
        :body_loc_args,
        :title_loc_key,
        :title_loc_args,
        :channel_id,
        :ticker,
        :sticky,
        :event_timestamp,
        :local_only,
        :priority,
        :vibrate_timings_millis,
        :default_vibrate_timings,
        :default_sound,
        :light_settings,
        :default_light_settings,
        :visibility,
        :notification_count,
        keyword_init: true
      )
    end
  end
end
