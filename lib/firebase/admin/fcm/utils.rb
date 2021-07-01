module Firebase
  module Admin
    module FCM
      module Utils

        def check_string(label, value, non_empty: false)
          return nil unless value
          raise ArgumentError, "#{label} must be a string." unless value.is_a?(String) || non_empty
          raise ArgumentError, "#{label} must be a non-empty string." unless value.is_a?(String) || !non_empty
          raise ArgumentError, "#{label} must be a non-empty string." if value.empty? && non_empty
          value
        end

        def check_numeric(label, value)
          return nil unless value
          raise ArgumentError, "#{label} must be a number." unless value.is_a?(Numeric)
          value
        end

        def check_string_hash(label, value)
          return nil if value.nil? || (value.is_a?(Hash) && value.empty?)
          raise ArgumentError, "#{label} must be a hash." unless value.is_a?(Hash)
          raise ArgumentError, "#{label} must not contain non-string values" unless value.values.all?(String)
          unless value.keys.all? { |k| k.is_a?(String) || k.is_a?(Symbol) }
            raise ArgumentError, "#{label} must not contain non-string or non-symbol values"
          end
          value
        end

        def check_string_array(label, value)
          return nil if value.nil? || (value.is_a?(Array) && value.empty?)
          raise ArgumentError, "#{label} must be an array of strings." unless value.is_a?(Array)
          raise ArgumentError, "#{label} must not contain non-string values" unless value.all?(String)
          value
        end

        def check_numeric_array(label, value)
          return nil if value.nil? || (value.is_a?(Array) && value.empty?)
          raise ArgumentError, "#{label} must be an array of numbers." unless value.is_a?(Array)
          raise ArgumentError, "#{label} must not contain non-numeric values" unless value.all?(Numeric)
          value
        end

        def check_analytics_label(label, value)
          return nil unless value
          value = check_string(label, value)
          raise ArgumentError, "#{label} is malformed" unless /\A[a-zA-Z0-9\-_.~%]{1,50}\Z/.match?(value)
          value
        end

        def check_time(label, value)
          return nil unless value
          raise ArgumentError, "#{label} must be a time." unless value.is_a?(Time)
          value
        end

        # @return [String, nil]
        def check_color(label, value, allow_alpha: false, required: false)
          return nil unless value || required
          raise ArgumentError, "#{label} is required" unless value
          raise ArgumentError, "#{label} must be a string" unless value.is_a?(String)
          unless /\A#[0-9a-fA-F]{6}\Z/.match?(value) || (/\A#[0-9a-fA-F]{8}\Z/.match?(value) && allow_alpha)
            raise ArgumentError, "#{label} must be in the form #RRGGBB" unless allow_alpha
            raise ArgumentError, "#{label} must be in the form #RRGGBB or #RRGGBBAA"
          end
          value
        end

        def to_seconds_string(seconds)
          has_nanos = (seconds - seconds.floor) > 0
          format(has_nanos ? "%0.9fs" : "%ds", seconds)
        end
      end
    end
  end
end
