module Firebase
  module Admin
    module FCM
      # Android-specific options that can be included in a {Message}.
      class AndroidConfig
        # @return [String, nil]
        #   Collapse key string for the message.
        #   This is an identifier for a group of messages that can be collapsed, so that only the last message is sent
        #   when delivery can be resumed. A maximum of 4 different collapse keys may be active at a given time.
        attr_accessor :collapse_key

        # @return [String, nil]
        #   Priority of the message. Must be either `high` or `normal`.
        attr_accessor :priority

        # @return [Numeric, nil]
        #   Time-to-live duration of the message in milliseconds.
        attr_accessor :ttl

        # @return [String, nil]
        #   Package name of the application where the registration tokens must match in order to receive the message.
        attr_accessor :restricted_package_name

        # @return [Hash<String, String>, nil]
        #   A hash of data fields to be included in the message. All keys and values must be strings.
        #   When provided, overrides any data fields set on the top-level message.
        attr_accessor :data

        # @return [AndroidNotification, nil]
        #   Android notification to be included in the message.
        attr_accessor :notification

        # @return [AndroidFCMOptions, nil]
        #   Options for features provided by the FCM SDK for Android.
        attr_accessor :fcm_options

        # Initializes an {AndroidConfig}.
        #
        # @param [String, nil] collapse_key
        #   Collapse key string for the message (optional).
        # @param [String, nil] priority
        #   Priority of the message (optional).
        #   Must be either `high` or `normal`.
        # @param [Numeric, nil] ttl
        #   The time-to-live duration of the message (optional).
        #   Time-to-live duration of the message in milliseconds.
        # @param [String, nil] restricted_package_name
        #   The package name of the application where the registration tokens must match in order to receive
        #   the message (optional).
        # @param [Hash<String, String>, nil] data
        #   A hash of data fields to be included in the message (optional).
        #   All keys and values must be strings.
        # @param [AndroidNotification, nil] notification
        #   An {AndroidNotification} to be included in the message (optional).
        # @param [AndroidFCMOptions, nil] fcm_options
        #   An {AndroidFCMOptions} to be included in the message (optional).
        def initialize(
          collapse_key: nil,
          priority: nil,
          ttl: nil,
          restricted_package_name: nil,
          data: nil,
          notification: nil,
          fcm_options: nil
        )
          self.collapse_key = collapse_key
          self.priority = priority
          self.ttl = ttl
          self.restricted_package_name = restricted_package_name
          self.data = data
          self.notification = notification
          self.fcm_options = fcm_options
        end
      end
    end
  end
end
