module Firebase
  module Admin
    module FCM
      # Represents settings to control notification LED that can be included in an {AndroidNotification}.
      class LightSettings
        # @return [String]
        #   Sets color of the LED in `#rrggbb` or `#rrggbbaa` format.
        attr_accessor :color

        # @return [Integer]
        #   Along with {light_off_duration_millis}, defines the blink rate of LED flashes.
        attr_accessor :light_on_duration_millis

        # @return [Integer]
        #   Along with {light_on_duration_millis}, defines the blink rate of LED flashes.
        attr_accessor :light_off_duration_millis

        # Initializes a {LightSettings}.
        #
        # @param [String] color
        #   The color of the LED in `#rrggbb` or `#rrggbbaa` format.
        # @param [Integer] light_on_duration_millis
        #   Along with {light_off_duration_millis}, defines the blink rate of LED flashes.
        # @param [Integer] light_off_duration_millis
        #   Along with {light_on_duration_millis}, defines the blink rate of LED flashes.
        def initialize(color:, light_on_duration_millis:, light_off_duration_millis:)
          self.color = color
          self.light_on_duration_millis = light_on_duration_millis
          self.light_off_duration_millis = light_off_duration_millis
        end
      end
    end
  end
end
