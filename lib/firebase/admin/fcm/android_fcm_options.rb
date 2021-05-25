module Firebase
  module Admin
    module FCM
      # Represents options for features provided by the FCM SDK for Android.
      #
      # @!attribute analytics_label
      #   @return [String, nil]
      #     The label associated with the message's analytics data.
      AndroidFCMOptions = Struct.new(:analytics_label, keyword_init: true)
    end
  end
end
