module Firebase
  module Admin
    module FCM
      # A client for communicating with the Firebase Cloud Messaging service.
      class Client
        FCM_HOST = "https://fcm.googleapis.com"
        IID_HOST = "https://iid.googleapis.com"
        IID_HEADERS = {access_token_auth: "true"}

        def initialize(app)
          @project_id = app.project_id
          @http_client = Firebase::Admin::Internal::HTTPClient.new(credentials: app.credentials)
          @message_encoder = MessageEncoder.new
        end

        # Sends a message via Firebase Cloud Messaging (FCM).
        #
        # If the `dry_run` flag is set, the message will not be actually delivered to the recipients.
        # Instead FCM performs all the usual validations, and emulates the send operation.
        #
        # @param [Message] message A message to send.
        # @param [Boolean] dry_run A flag indicating whether to run the operation in dry run mode.
        #
        # @return [String] A message id that uniquely identifies the message.
        def send(message, dry_run: false)
          raise NotImplementedError
        end

        # Sends the given list of messages via Firebase Cloud Messaging (FCM) as a single batch.
        #
        # If the `dry_run` flag is set, the messages will not be actually delivered to the recipients.
        # Instead FCM performs all the usual validations, and emulates the send operation.
        #
        # @param [Array<Message>] messages An array of messages to send.
        # @param [Boolean] dry_run A flag indicating whether to run the operation in dry run mode.
        #
        # @return [BatchResponse] A batch response.
        def send_all(messages, dry_run: false)
          raise NotImplementedError
        end

        # Sends the given multicast message to all tokens via Firebase Cloud Messaging (FCM).
        #
        # If the `dry_run` flag is set, the message will not be actually delivered to the recipients.
        # Instead FCM performs all the usual validations, and emulates the send operation.
        #
        # @param [MulticastMessage] message A multicast message to send.
        # @param [Boolean] dry_run A flag indicating whether to run the operation in dry run mode.
        #
        # @return [BatchResponse] A batch response.
        def send_multicast(message, dry_run: false)
          raise NotImplementedError
        end

        # Subscribes a list of registration tokens to an FCM topic.
        #
        # @param [Array<String>] tokens An array of device registration tokens (max 1000).
        # @param [String] topic Name of the topic to subscribe to. May contain the `/topics` prefix.
        #
        # @return [TopicManagementResponse] A topic management response.
        def subscribe_to_topic(tokens, topic)
          raise NotImplementedError
        end

        # Unsubscribes a list of registration tokens from an FCM topic.
        #
        # @param [Array<String>] tokens An array of device registration tokens (max 1000).
        # @param [String] topic Name of the topic to unsubscribe from. May contain the `/topics` prefix.
        #
        # @return [TopicManagementResponse] A topic management response.
        def unsubscribe_from_topic(tokens, topic)
          raise NotImplementedError
        end

        private

      end
    end

    class App
      # Gets the Firebase Cloud Messaging client for this App.
      # @return [Firebase::Admin::FCM::Client]
      def fcm
        @fcm_client ||= FCM::Client.new(self)
      end
    end
  end
end
