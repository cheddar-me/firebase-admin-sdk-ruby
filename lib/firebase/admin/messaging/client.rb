module Firebase
  module Admin
    module Messaging
      # A client for communicating with the Firebase Cloud Messaging service.
      class Client
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
        def send_one(message, dry_run: false)
          body = {
            validate_only: dry_run,
            message: @message_encoder.encode(message)
          }
          res = @http_client.post(send_url, body, FCM_HEADERS)
          res.body["name"]
        rescue Faraday::Error => e
          raise parse_fcm_error(e)
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
        # @param [MulticastMessage] multicast_message A multicast message to send.
        # @param [Boolean] dry_run A flag indicating whether to run the operation in dry run mode.
        #
        # @return [BatchResponse] A batch response.
        def send_multicast(multicast_message, dry_run: false)
          messages = multicast_message.tokens.map do |token|
            Message.new(
              token: token,
              data: multicast_message.data,
              notification: multicast_message.notification,
              android: multicast_message.android,
              apns: multicast_message.apns,
              fcm_options: multicast_message.fcm_options
            )
          end
          send_all(messages, dry_run: dry_run)
        end

        # Subscribes a list of registration tokens to an FCM topic.
        #
        # @param [Array<String>, String] tokens An array of device registration tokens (max 1000).
        # @param [String] topic Name of the topic to subscribe to. May contain the `/topics` prefix.
        #
        # @return [TopicManagementResponse] A topic management response.
        def subscribe_to_topic(tokens, topic)
          make_topic_mgmt_request(tokens, topic, "batchAdd")
        end

        # Unsubscribes a list of registration tokens from an FCM topic.
        #
        # @param [Array<String>, String] tokens An array of device registration tokens (max 1000).
        # @param [String] topic Name of the topic to unsubscribe from. May contain the `/topics` prefix.
        #
        # @return [TopicManagementResponse] A topic management response.
        def unsubscribe_from_topic(tokens, topic)
          make_topic_mgmt_request(tokens, topic, "batchRemove")
        end

        private

        # @return [String] The firebase cloud messaging send endpoint url.
        def send_url
          "#{FCM_HOST}/v1/projects/#{@project_id}/messages:send"
        end

        # @return [String] The topic management endpoint url.
        def topic_mgmt_url(operation)
          "#{IID_HOST}/iid/v1:#{operation}"
        end

        def make_topic_mgmt_request(tokens, topic, operation)
          tokens = [tokens] if tokens.is_a?(String)

          unless tokens.is_a?(Array) && !tokens.empty?
            raise ArgumentError, "tokens must be a string or non-empty array of strings."
          end

          unless tokens.all?(String)
            raise ArgumentError, "tokens must be a non-empty array of strings."
          end

          unless topic.is_a?(String) && !topic.empty?
            raise ArgumentError, "topic must be a non-empty string."
          end

          unless %w[batchAdd batchRemove].include?(operation)
            raise ArgumentError, "operation is invalid"
          end

          uri = topic_mgmt_url(operation)
          res = @http_client.post(uri, {
            to: @message_encoder.sanitize_topic_name(topic, strip_prefix: false),
            registration_tokens: tokens
          }, IID_HEADERS)
          TopicManagementResponse.new(res)
        end

        # @param [Faraday::Error] err
        def parse_fcm_error(err)
          msg, info = parse_platform_error(err.response_status, err.response_body)
          return err if info.empty?

          details = info["details"] || []
          detail = details.find { |detail| detail["@type"] == "type.googleapis.com/google.firebase.fcm.v1.FcmError" }
          return err unless detail.is_a?(Hash)

          cls = FCM_ERROR_TYPES[detail["errorCode"] || ""] || Error
          cls.new(msg, info)
        rescue JSON::ParserError
          Error.new("HTTP response is not json.", err.response)
        end

        # Parses an HTTP error response from a Google Cloud Platform API and extracts the error code
        # and message fields.
        #
        # @param [Integer] status_code
        # @param [String] body
        # @return Array<String,Hash>
        def parse_platform_error(status_code, body)
          parsed = JSON.parse(body)
          data = parsed.is_a?(Hash) ? parsed : {}
          details = data.fetch("error", {})
          msg = details.fetch("message", "Unexpected HTTP response with status #{status_code}; body: #{body}")
          [msg, details]
        end

        FCM_HOST = "https://fcm.googleapis.com"
        FCM_HEADERS = {"X-GOOG-API-FORMAT-VERSION": "2"}
        IID_HOST = "https://iid.googleapis.com"
        IID_HEADERS = {"access_token_auth" => "true"}

        FCM_ERROR_TYPES = {
          "APNS_AUTH_ERROR" => ThirdPartyAuthError,
          "INVALID_ARGUMENT" => InvalidArgumentError,
          "QUOTA_EXCEEDED" => QuotaExceededError,
          "SENDER_ID_MISMATCH" => SenderIdMismatchError,
          "THIRD_PARTY_AUTH_ERROR" => ThirdPartyAuthError,
          "UNREGISTERED" => UnregisteredError,
          "UNSPECIFIED_ERROR" => UnspecifiedError
        }
      end
    end

    class App
      # Gets the Firebase Cloud Messaging client for this App.
      # @return [Firebase::Admin::Messaging::Client]
      def messaging
        @messaging_client ||= Messaging::Client.new(self)
      end
    end
  end
end
