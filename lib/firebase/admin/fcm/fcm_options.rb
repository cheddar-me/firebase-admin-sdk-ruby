module Firebase
  module Admin
    module FCM
      # Represents options for features provided by the FCM SDK.
      class FCMOptions
        # @return [String, nil] Label associated with the message's analytics data.
        attr_accessor :analytics_label

        # Initializes an {FCMOptions}.
        #
        # @param [String, nil] analytics_label
        #   The label associated with the message's analytics data (optional).
        def initialize(analytics_label: nil)
          self.analytics_label = analytics_label
        end
      end
    end
  end
end
