module Firebase
  module Admin
    module Messaging
      # Aps dictionary to be included in an APNS payload.
      class APS
        # @return [Firebase::Admin::Messaging::APSAlert, String, nil]
        #   Alert to be included in the message.
        attr_accessor :alert

        # @return [Integer, nil]
        #   Badge to be displayed with the message. Set to 0 to remove the badge. When not specified, the badge will
        #   remain unchanged.
        attr_accessor :badge

        # @return [Firebase::Admin::Messaging::CriticalSound, String, nil]
        #   Sound to be played with the message.
        attr_accessor :sound

        # @return [Boolean, nil]
        #   Specifies whether to configure a background update notification.
        attr_accessor :content_available

        # @return [Boolean, nil]
        #   Specifies whether to set the `mutable-content` property on the message so the clients can modify the
        #   notification via app extensions.
        attr_accessor :mutable_content

        # @return [String, nil]
        #   Type of the notification.
        attr_accessor :category

        # @return [String, nil]
        #   An app-specific identifier for grouping notifications.
        attr_accessor :thread_id

        # @return [Hash]
        #   App-specific custom fields.
        attr_accessor :custom_data

        # Initializes an {APS}.
        #
        # @param [Firebase::Admin::Messaging::APSAlert, String, nil] alert
        #   Alert to be included in the message (optional).
        # @param [Integer, nil] badge
        #   Badge to be displayed with the message (optional).
        #   Set to 0 to remove the badge. When not specified, the badge will remain unchanged.
        # @param [Firebase::Admin::Messaging::CriticalSound, String, nil] sound
        #   Sound to be played with the message (optional).
        # @param [Boolean, nil] content_available
        #   Specifies whether to configure a background update notification (optional).
        # @param [Boolean, nil] mutable_content
        #   Specifies whether to set the `mutable-content` property on the message so the clients can modify the
        #   notification via app extensions (optional).
        # @param [String, nil] category
        #   Type of the notification (optional).
        # @param [String, nil] thread_id
        #   An app-specific identifier for grouping notifications (optional).
        # @param [Hash, nil] custom_data
        #   App-specific custom fields (optional).
        def initialize(
          alert: nil,
          badge: nil,
          sound: nil,
          content_available: nil,
          mutable_content: nil,
          category: nil,
          thread_id: nil,
          custom_data: nil
        )
          self.alert = alert
          self.badge = badge
          self.sound = sound
          self.content_available = content_available
          self.mutable_content = mutable_content
          self.category = category
          self.thread_id = thread_id
          self.custom_data = custom_data
        end
      end
    end
  end
end
