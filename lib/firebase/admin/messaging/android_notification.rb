module Firebase
  module Admin
    module Messaging
      # Android-specific notification options that can be included in an {AndroidConfig}.
      class AndroidNotification
        # @return [String, nil]
        #   Title of the Android notification. When provided, overrides the title set via {Notification}.
        attr_accessor :title

        # @return [String, nil]
        #   Body of the Android notification. When provided, overrides the body set via {Notification}.
        attr_accessor :body

        # @return [String, nil]
        #   Icon resource for the Android notification.
        attr_accessor :icon

        # @return [String, nil]
        #   Notification icon color in `#rrggbb` format.
        attr_accessor :color

        # @return [String, nil]
        #   File name of the sound to be played when the device receives the notification.
        attr_accessor :sound

        # @return [String, nil]
        #   Notification tag. This is an identifier used to replace existing notifications in the notification drawer.
        #   If not specified, each request creates a new notification.
        attr_accessor :tag

        # @return [String, nil]
        #   URL of an image to be displayed in the notification.
        attr_accessor :image

        # @return [String, nil]
        #   Action associated with a user click on the notification. If specified, an activity with a matching
        #   Intent Filter is launched when a user clicks on the notification.
        attr_accessor :click_action

        # @return [String, nil]
        #   Key of the body string in the app's string resource to use to localize the body text.
        attr_accessor :body_loc_key

        # @return [Array<String>, nil]
        #   An array of resource keys that will be used in place of the format specifiers in {body_loc_key}.
        attr_accessor :body_loc_args

        # @return [String, nil]
        #   Key of the title string in the app's string resource to use to localize the title text.
        attr_accessor :title_loc_key

        # @return [Array<String>, nil]
        #   An array of resource keys that will be used in place of the format specifiers in {title_loc_key}.
        attr_accessor :title_loc_args

        # @return [String, nil]
        #   The Android notification channel id (new in Android O). The app must create a channel with this channel id
        #   before any notification with this channel id can be received. If you don't send this channel id in the
        #   request, or if the channel id provided has not yet been created by the app, FCM uses the channel id
        #   specified in the app manifest.
        attr_accessor :channel_id

        # @return [String, nil]
        #   Sets the "ticker" text, which is sent to accessibility services. Prior to API level 21 (Lollipop), sets the
        #   text that is displayed in the status bar when the notification first arrives.
        attr_accessor :ticker

        # @return [Boolean, nil]
        #   When set to `false` or unset, the notification is automatically dismissed when the user clicks it in the
        #   panel. When set to `true`, the notification persists even when the user clicks it.
        attr_accessor :sticky

        # @return [Time, nil]
        #   For notifications that inform users about events with an absolute time reference, sets the time that the
        #   event in the notification occurred. Notifications in the panel are sorted by this time.
        attr_accessor :event_time

        # @return [Boolean, nil]
        #   Sets whether or not this notification is relevant only to the current device. Some notifications can be
        #   bridged to other devices for remote display, such as a Wear OS watch. This hint can be set to recommend
        #   this notification not be bridged.
        attr_accessor :local_only

        # @return [String, nil]
        #   Sets the relative priority for this notification. Low-priority notifications may be hidden from the user in
        #   certain situations. Note this priority differs from `AndroidMessagePriority`. This priority is processed by
        #   the client after the message has been delivered. Whereas `AndroidMessagePriority` is an FCM concept that
        #   controls when the message is delivered.
        attr_accessor :priority

        # @return [Array<Numeric>, nil]
        #   Sets the vibration pattern to use. Pass in an array of numeric durations to turn the vibrator on or off. The
        #   first value indicates the duration to wait before turning the vibrator on. The next value indicates the
        #   duration to keep the vibrator on. Subsequent values alternate between duration to turn the vibrator off and
        #   to turn the vibrator on. If `vibrate_timings` is set and `default_vibrate_timings` is set to `true`, the
        #   default value is used instead of the user-specified `vibrate_timings`.
        attr_accessor :vibrate_timings

        # @return [Boolean, nil]
        #   If set to `true`, use the Android framework's default vibrate pattern for the notification. Default values
        #   are specified in `config.xml`. If `default_vibrate_timings` is set to `true` and `vibrate_timings` is also
        #   set, the default value is used instead of the user-specified `vibrate_timings`.
        # @see https://android.googlesource.com/platform/frameworks/base/+/master/core/res/res/values/config.xml
        attr_accessor :default_vibrate_timings

        # @return [Boolean, nil]
        #   If set to `true`, use the Android framework's default sound for the notification. Default values are
        #   specified in `config.xml`.
        # @see https://android.googlesource.com/platform/frameworks/base/+/master/core/res/res/values/config.xml
        attr_accessor :default_sound

        # @return [LightSettings, nil]
        #   Settings to control the notification's LED blinking rate and color if LED is available on the device.
        #   The total blinking time is controlled by the OS.
        attr_accessor :light_settings

        # @return [Boolean, nil]
        #   If set to `true`, use the Android framework's default LED light settings for the notification. Default
        #   values are specified in `config.xml`. If `default_light_settings` is set to `true` and `light_settings` is
        #   also set, the user-specified `light_settings` is used instead of the default value.
        # @see https://android.googlesource.com/platform/frameworks/base/+/master/core/res/res/values/config.xml
        attr_accessor :default_light_settings

        # @return [String, nil]
        #   Sets the visibility of the notification. Must be either `private`, `public`, or `secret`. If unspecified,
        #   defaults to `private`.
        attr_accessor :visibility

        # @return [Integer, nil]
        #   Sets the number of items this notification represents. May be displayed as a badge count for Launchers that
        #   support badging. For example, this might be useful if you're using just one notification to represent
        #   multiple new messages but you want the count here to represent the number of total new messages. If zero
        #   or unspecified, systems that support badging use the default, which is to increment a number displayed on
        #   the long-press menu each time a new notification arrives.
        # @see https://developer.android.com/training/notify-user/badges
        attr_accessor :notification_count

        # Initializes an AndroidNotification
        #
        # @param [String, nil] title
        # @param [String, nil] body
        # @param [String, nil] icon
        # @param [String, nil] color
        # @param [String, nil] sound
        # @param [String, nil] tag
        # @param [String, nil] image
        # @param [String, nil] click_action
        # @param [String, nil] body_loc_key
        # @param [Array<String>, nil] body_loc_args
        # @param [String, nil] title_loc_key
        # @param [Array<String>, nil] title_loc_args
        # @param [String, nil] channel_id
        # @param [String, nil] ticker
        # @param [Boolean, nil] sticky
        # @param [Time, nil] event_time
        # @param [Boolean, nil] local_only
        # @param [String, nil] priority
        # @param [Array<Numeric>, nil] vibrate_timings
        # @param [Boolean, nil] default_vibrate_timings
        # @param [Boolean, nil] default_sound
        # @param [LightSettings, nil] light_settings
        # @param [Boolean, nil] default_light_settings
        # @param [String, nil] visibility
        # @param [Integer, nil] notification_count
        def initialize(
          title: nil,
          body: nil,
          icon: nil,
          color: nil,
          sound: nil,
          tag: nil,
          image: nil,
          click_action: nil,
          body_loc_key: nil,
          body_loc_args: nil,
          title_loc_key: nil,
          title_loc_args: nil,
          channel_id: nil,
          ticker: nil,
          sticky: nil,
          event_time: nil,
          local_only: nil,
          priority: nil,
          vibrate_timings: nil,
          default_vibrate_timings: nil,
          default_sound: nil,
          light_settings: nil,
          default_light_settings: nil,
          visibility: nil,
          notification_count: nil
        )
          self.title = title
          self.body = body
          self.icon = icon
          self.color = color
          self.sound = sound
          self.tag = tag
          self.image = image
          self.click_action = click_action
          self.body_loc_key = body_loc_key
          self.body_loc_args = body_loc_args
          self.title_loc_key = title_loc_key
          self.title_loc_args = title_loc_args
          self.channel_id = channel_id
          self.ticker = ticker
          self.sticky = sticky
          self.event_time = event_time
          self.local_only = local_only
          self.priority = priority
          self.vibrate_timings = vibrate_timings
          self.default_vibrate_timings = default_vibrate_timings
          self.default_sound = default_sound
          self.light_settings = light_settings
          self.default_light_settings = default_light_settings
          self.visibility = visibility
          self.notification_count = notification_count
        end
      end
    end
  end
end
