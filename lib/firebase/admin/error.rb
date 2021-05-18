module Firebase
  module Admin
    # A base class for errors raised by the admin sdk.
    class Error < StandardError; end

    # Raised when there is an incorrect argument.
    class ArgumentError < Error; end
  end
end
