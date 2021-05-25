module Firebase
  module Admin
    module FCM
      # Options for features provided by the FCM SDK for iOS.
      #
      # @!attribute analytics_label
      #   @return [String, nil]
      #     The label associated with the message's analytics data.
      #
      # @!attribute image_url
      #   @return [String, nil]
      #     URL of an image to be displayed in the notification.
      APNSFCMOptions = Struct.new(:analytics_label, :image_url, keyword_init: true)
    end
  end
end
