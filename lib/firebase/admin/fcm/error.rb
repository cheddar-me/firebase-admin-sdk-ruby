module Firebase
  module Admin
    module FCM
      class Error < Firebase::Admin::Error; end

      class ThirdPartyAuthError < Error; end

      class QuotaExceededError < Error; end

      class SenderIdMismatchError < Error; end

      class UnregisteredError < Error; end
    end
  end
end
