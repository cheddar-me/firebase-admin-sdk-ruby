module Firebase
  module Admin
    module FCM
      # Represents the payload of an APNs message.
      #
      # Mainly consists of the `aps` dictionary. But may also contain other arbitrary custom keys.
      #
      class APNSPayload
        # @return [APS] The aps instance to be included in the payload.
        attr_accessor :aps

        # @return [Hash] Custom fields to include in the payload.
        attr_accessor :custom_data

        # Initializes a payload.
        #
        # @param [APS] aps
        #   An {APS} instance to be included in the payload.
        # @param [Hash] custom_data
        #   Arbitrary keyword arguments to be included as custom fields in the payload.
        def initialize(aps, custom_data = {})
          @aps = aps
          @custom_data = custom_data
        end
      end
    end
  end
end
