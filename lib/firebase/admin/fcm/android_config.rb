module Firebase
  module Admin
    module FCM
      # Android-specific options that can be included in a {Message}.
      #
      # @!attribute collapse_key
      #   @return [String, nil]
      #     Collapse key string for the message. This is an identifier for a group of messages that can be collapsed,
      #     so that only the last message is sent when delivery can be resumed. A maximum of 4 different collapse keys
      #     may be active at a given time.
      #
      # @!attribute priority
      #   @return [String, nil]
      #     Priority of the message. Must be either `high` or `normal`.
      #
      # @!attribute ttl
      #   @return [Numeric, nil]
      #     Time-to-live duration of the message in milliseconds.
      #
      # @!attribute restricted_package_name
      #   @return [String, nil]
      #     Package name of the application where the registration tokens must match in order to receive the message.
      #
      # @!attribute data
      #   @return [Hash<String, String>, nil]
      #     A collection of data fields to be included in the message. All values must be strings. When provided,
      #     overrides any data fields set on the top-level message.
      #
      # @!attribute notification
      #   @return [AndroidNotification, nil]
      #     Android notification to be included in the message.
      #
      # @!attribute fcm_options
      #   @return [AndroidFCMOptions, nil]
      #     Options for features provided by the FCM SDK for Android.
      AndroidConfig = Struct.new(
        :collapse_key,
        :priority,
        :ttl,
        :restricted_package_name,
        :data,
        :notification,
        :fcm_options,
        keyword_init: true
      )
    end
  end
end
