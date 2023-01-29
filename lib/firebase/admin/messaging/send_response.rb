module Firebase
  module Admin
    module Messaging
      # The response received from an individual batched request.
      class SendResponse
        # A message id string that uniquely identifies the message.
        # @return [String]
        attr_reader :message_id

        # The error if one occurred while sending the message.
        # @return [Error]
        attr_reader :error

        # A boolean indicating if the request was successful.
        # @return [Boolean]
        def success?
          !!@message_id
        end

        # Initializes the object.
        #
        # @param [String, nil] message_id the id of the sent message
        # @param [Error, nil] error the error that occurred
        def initialize(message_id:, error:)
          @message_id = message_id
          @error = error
        end
      end
    end
  end
end
