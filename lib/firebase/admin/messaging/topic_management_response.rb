module Firebase
  module Admin
    module Messaging
      # A response received from a topic management operation.
      class TopicManagementResponse
        # @return [Integer] The number of tokens successfully subscribed or unsubscribed.
        attr_reader :success_count

        # @return [Integer] The number of tokens that could not be subscribed or unsubscribed due to errors.
        attr_reader :failure_count

        # @return [Array<ErrorInfo>] An array of {ErrorInfo} objects (possibly empty).
        attr_reader :errors

        # Initializes a {TopicManagementResponse}.
        #
        # @param [Faraday::Response] response
        #   The response received from the api.
        def initialize(response)
          unless response.body.is_a?(Hash) && response.body["results"].is_a?(Array)
            raise Error.new("Unexpected topic management response", response)
          end

          @success_count = 0
          @failure_count = 0
          @errors = []

          results = response.body["results"]
          results.each_with_index do |result, i|
            if (reason = result["error"])
              @failure_count += 1
              @errors << ErrorInfo.new(index: i, reason: reason)
            else
              @success_count += 1
            end
          end
        end
      end
    end
  end
end
