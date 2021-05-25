module Firebase
  module Admin
    module FCM
      # A notification that can be included in a message.
      #
      # @!attribute title
      #   @return [String, nil]
      #     Title of the notification.
      #
      # @!attribute body
      #   @return [String, nil]
      #     Body of the notification.
      #
      # @!attribute image
      #   @return [String, nil]
      #     Image url of the notification.
      Notification = Struct.new(:title, :body, :image, keyword_init: true)
    end
  end
end
