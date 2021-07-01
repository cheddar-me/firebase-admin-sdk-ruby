module Firebase
  module Admin
    module FCM
      # Options for features provided by the FCM SDK for iOS.
      class APNSFCMOptions
        # @return [String, nil]
        #   The label associated with the message's analytics data.
        attr_accessor :analytics_label

        # @return [String, nil]
        #   URL of an image to be displayed in the notification.
        attr_accessor :image

        # Initializes an {APNSFCMOptions}.
        #
        # @param [String, nil] analytics_label
        #   The label associated with the message's analytics data (optional).
        # @param [String, nil] image
        #   URL of an image to be displayed in the notification (optional).
        def initialize(analytics_label: nil, image: nil)
          self.analytics_label = analytics_label
          self.image = image
        end
      end
    end
  end
end
