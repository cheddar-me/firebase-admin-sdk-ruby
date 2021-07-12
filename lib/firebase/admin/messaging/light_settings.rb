module Firebase
  module Admin
    module Messaging
      # Represents settings to control notification LED that can be included in an {AndroidNotification}.
      class LightSettings
        # @return [String]
        #   Sets color of the LED in `#rrggbb` or `#rrggbbaa` format.
        attr_accessor :color

        # @return [Numeric]
        #   Along with {light_off_duration}, defines the blink rate of LED flashes.
        attr_accessor :light_on_duration

        # @return [Numeric]
        #   Along with {light_on_duration}, defines the blink rate of LED flashes.
        attr_accessor :light_off_duration

        # Initializes a {LightSettings}.
        #
        # @param [String] color
        #   The color of the LED in `#rrggbb` or `#rrggbbaa` format.
        # @param [Numeric] light_on_duration
        #   Along with {light_off_duration}, defines the blink rate of LED flashes.
        # @param [Numeric] light_off_duration
        #   Along with {light_on_duration}, defines the blink rate of LED flashes.
        def initialize(color:, light_on_duration:, light_off_duration:)
          self.color = color
          self.light_on_duration = light_on_duration
          self.light_off_duration = light_off_duration
        end
      end
    end
  end
end
