module Firebase
  module Admin
    module Messaging
      # Information on an error encountered when performing a topic management operation.
      class ErrorInfo
        # @return [Integer] The index of the registration token the error is related to.
        attr_accessor :index

        # @return [String] The description of the error encountered.
        attr_accessor :reason

        # Initializes an {ErrorInfo}.
        #
        # @param [Integer] index
        #   The index of the registration token the error is related to.
        # @param [String] reason
        #   The description of the error encountered.
        def initialize(index:, reason:)
          self.index = index
          self.reason = reason
        end
      end
    end
  end
end
