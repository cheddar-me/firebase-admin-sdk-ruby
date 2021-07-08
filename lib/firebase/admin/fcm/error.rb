module Firebase
  module Admin
    module FCM
      # A base class for errors raised by the admin sdk fcm client.
      class Error < Firebase::Admin::Error
        attr_reader :info

        def initialize(msg, info = nil)
          @info = info
          super(msg)
        end
      end

      # No more information is available about this error.
      class UnspecifiedError < Error; end

      # Request parameters were invalid.
      class InvalidArgumentError < Error; end

      # A message targeted to an iOS device or a web push registration could not be sent.
      # Check the validity of your development and production credentials.
      class ThirdPartyAuthError < Error; end

      # This error can be caused by exceeded message rate quota, exceeded device message rate quota, or
      # exceeded topic message rate quota.
      class QuotaExceededError < Error; end

      # The authenticated sender ID is different from the sender ID for the registration token.
      class SenderIdMismatchError < Error; end

      # App instance was unregistered from FCM. This usually means that the token used is no longer valid and
      # a new one must be used.
      class UnregisteredError < Error; end
    end
  end
end
