module Firebase
  module Admin
    module Messaging
      # The response received from a batch request
      class BatchResponse
        # The list of responses (possibly empty).
        # @return [Array<SendResponse>]
        attr_reader responses

        # The number of successful messages.
        # @return [Integer]
        attr_reader success_count

        # The number of failed messages.
        # @return [Integer]
        attr_reader failure_count

        # A response received from a batch request.
        #
        # @param [Array<SendResponse>] responses
        def initialize(responses:)
          @responses = responses
          @success_count = responses.count(:success?)
          @failure_count = responses.count - @success_count
        end
      end
    end
  end
end
