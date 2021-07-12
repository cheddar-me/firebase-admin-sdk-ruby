module Firebase
  module Admin
    module Messaging
      # Critical alert sound configuration that can be included in an {APS}
      class CriticalSound
        # @return [String]
        #   The name of a sound file in the app's main bundle or in the `Library/Sounds` folder of the app's container
        #   directory. Specify the string "default" to play the system sound.
        attr_accessor :name

        # @return [Boolean, nil]
        #   The critical alert flag. Set to `true` to enable the critical alert.
        attr_accessor :critical

        # @return [Float, nil]
        #   The volume for the critical alert's sound. Must be a value between 0.0 (silent) and 1.0 (full volume).
        attr_accessor :volume

        # Initializes a {CriticalSound}.
        #
        # @param [String] name
        #   The name of a sound file in the app's main bundle or in the `Library/Sounds` folder of teh app's container
        #   directory.
        # @param [Boolean, nil] critical
        #   The critical alert flag (optional).
        # @param [Float, nil] volume
        #   The volume for the critical alert's sound (optional). Must be a value between 0.0 (silent) and 1.0 (full
        #   volume).
        def initialize(name: "default", critical: nil, volume: nil)
          self.name = name
          self.critical = critical
          self.volume = volume
        end
      end
    end
  end
end
