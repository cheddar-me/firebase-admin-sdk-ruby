module Firebase
  module Admin
    module FCM
      # Critical alert sound configuration that can be included in an {APS}
      #
      # @!attribute name
      #   @return [String]
      #     The name of a sound file in the app's main bundle or in the `Library/Sounds` folder of the app's container
      #     directory. Specify the string "default" to play the system sound.
      #
      # @!attribute critical
      #   @return [Boolean, nil]
      #     The critical alert flag. Set to `true` to enable the critical alert.
      #
      # @!attribute volume
      #   @return [Float, nil]
      #     The volume for the critical alert's sound. Must be a value between 0.0 (silent) and 1.0 (full volume).
      CriticalSound = Struct.new(:name, :critical, :volume, keyword_init: true)
    end
  end
end
