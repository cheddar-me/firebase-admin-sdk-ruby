module Firebase
  module Admin
    module FCM
      # Represents settings to control notification LED that can be included in an {AndroidNotification}.
      #
      # @!attribute color
      #   @return [String]
      #     Sets color of the LED in `#rrggbb` or `#rrggbbaa` format.
      #
      # @!attribute light_on_duration_millis
      #   @return [Integer]
      #     Along with {light_off_duration_millis}, defines the blink rate of LED flashes.
      #
      # @!attribute light_off_duration_millis
      #   @return [Integer]
      #     Along with {light_on_duration_millis}, defines the blink rate of LED flashes.
      LightSettings = Struct.new(:color, :light_on_duration_millis, :light_off_duration_millis, keyword_init: true)
    end
  end
end
