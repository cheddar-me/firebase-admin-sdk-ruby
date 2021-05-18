require "addressable/uri"

module Firebase
  module Admin
    module Auth
      module Utils

        private

        def validate_uid(uid, required: false)
          return nil if uid.nil? && !required
          raise ArgumentError, "uid must be a string" unless uid.is_a?(String)
          raise ArgumentError, "uid must be non-empty with no more than 128 chars" unless uid.length.between?(1, 128)
          uid
        end

        def validate_email(email, required: false)
          return nil if email.nil? && !required
          raise ArgumentError, "email must be a non-empty string" unless email.is_a?(String) && !email.empty?
          parts = email.split("@")
          raise ArgumentError, "email is malformed #{email}" unless parts.length == 2 && !parts[0].empty? && !parts[1].empty?
          email
        end

        def validate_phone_number(phone_number, required: false)
          return nil if phone_number.nil? && !required
          raise ArgumentError, "phone_number must be a non-empty string" unless phone_number.is_a?(String)
          raise ArgumentError, "phone_number must be an E.164 identifier" unless phone_number.match?(/^\+\d{1,14}$/)
          phone_number
        end

        def validate_password(password, required: false)
          return nil if password.nil? && !required
          raise ArgumentError, "password must a string" unless password.is_a?(String)
          raise ArgumentError, "password must be at least 6 characters long" unless password.length >= 6
          password
        end

        def validate_photo_url(photo_url, required: false)
          return nil if photo_url.nil? && !required
          raise ArgumentError, "photo_url must be a non-empty string" unless photo_url.is_a?(String) && !photo_url.empty?
        end

        def validate_display_name(name, required: false)
          return nil if name.nil? && !required
          raise ArgumentError, "display_name must be a non-empty string" unless name.is_a?(String) && !name.empty?
        end

        def to_boolean(val)
          return nil if val.nil?
          !!val
        end
      end
    end
  end
end
