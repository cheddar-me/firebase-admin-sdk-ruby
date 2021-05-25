module Firebase
  module Admin
    module FCM
      # APNS-specific options that can be included in a {Message}.
      #
      # Refer to `APNS Documentation` for more information.
      # @see https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html
      #
      # @!attribute headers
      #   @return [Hash<String, String>, nil]
      #     A collection of APNs headers. Header values must be strings.
      #
      # @!attribute payload
      #   @return [APNSPayload, nil]
      #     An APNs payload to be included in the message.
      #
      # @!attribute fcm_options
      #   @return [APNSFCMOptions, nil]
      #     Options for features provided by the FCM SDK for iOS.
      APNSConfig = Struct.new(:headers, :payload, :fcm_options, keyword_init: true)
    end
  end
end
