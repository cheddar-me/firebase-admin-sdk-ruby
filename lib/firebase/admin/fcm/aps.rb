module Firebase
  module Admin
    module FCM
      # Aps dictionary to be included in an APNS payload.
      #
      # @!attribute alert
      #   @return [String, APSAlert, nil]
      #     Alert to be included in the message.
      #
      # @!attribute badge
      #   @return [Integer, nil]
      #     Badge to be displayed with the message. Set to 0 to remove the badge. When not specified, the badge will
      #     remain unchanged.
      #
      # @!attribute sound
      #   @return [String, CriticalSound, nil]
      #     Sound to be played with the message.
      #
      # @!attribute content_available
      #   @return [Boolean, nil]
      #     Specifies whether to configure a background update notification.
      #
      # @!attribute mutable_content
      #   @return [Boolean, nil]
      #     Specifies whether to set the `mutable-content` property on the message so the clients can modify the
      #     notification via app extensions.
      #
      # @!attribute category
      #   @return [String, nil]
      #     Type of the notification.
      #
      # @!attribute thread_id
      #   @return [String, nil]
      #     An app-specific identifier for grouping notifications.
      #
      # @!attribute custom_data
      #   @return [Hash]
      #     App-specific custom fields.
      APS = Struct.new(
        :alert,
        :badge,
        :sound,
        :content_available,
        :mutable_content,
        :category,
        :thread_id,
        :custom_data,
        keyword_init: true
      )
    end
  end
end
