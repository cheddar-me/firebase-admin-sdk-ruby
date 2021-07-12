module Firebase
  module Admin
    module FCM
      class MessageEncoder
        # Encodes a {Message}.
        #
        # @param [Message] message
        #   The message to encode.
        # @return [Hash]
        def encode(message)
          raise ArgumentError, "message must be a Message" unless message.is_a?(Message)
          result = {
            android: encode_android(message.android),
            apns: encode_apns(message.apns),
            condition: check_string("Message.condition", message.condition, non_empty: true),
            data: check_string_hash("Message.data", message.data),
            notification: encode_notification(message.notification),
            token: check_string("Message.token", message.token, non_empty: true),
            topic: check_string("Message.topic", message.topic, non_empty: true),
            fcm_options: encode_fcm_options(message.fcm_options)
          }
          result[:topic] = sanitize_topic_name(result[:topic])
          result = remove_nil_values(result)
          unless result.count { |k, _| [:token, :topic, :condition].include?(k) } == 1
            raise ArgumentError, "Exactly one token, topic or condition must be specified"
          end
          result
        end

        # @return [String, nil]
        def sanitize_topic_name(topic, strip_prefix: true)
          return nil unless topic
          prefix = "/topics/"
          if topic.start_with?(prefix)
            topic = topic[prefix.length..]
          end
          unless /\A[a-zA-Z0-9\-_.~%]+\Z/.match?(topic)
            raise ArgumentError, "Malformed topic name."
          end
          strip_prefix ? topic : "/topics/#{topic}"
        end

        private

        # @return [Hash, nil]
        def encode_android(v)
          return nil unless v
          raise ArgumentError, "Message.android must be an AndroidConfig." unless v.is_a?(AndroidConfig)
          result = {
            collapse_key: check_string("AndroidConfig.collapse_key", v.collapse_key),
            data: check_string_hash("AndroidConfig.data", v.data),
            notification: encode_android_notification(v.notification),
            priority: check_string("AndroidConfig.priority", v.priority, non_empty: true),
            restricted_package_name: check_string("AndroidConfig.restricted_package_name", v.restricted_package_name),
            ttl: encode_duration("AndroidConfig.ttl", v.ttl),
            fcm_options: encode_android_fcm_options(v.fcm_options)
          }
          result = remove_nil_values(result)
          if result.key?(:priority) && !%w[normal high].include?(result[:priority])
            raise ArgumentError, "AndroidConfig.priority must be 'normal' or 'high'"
          end
          result
        end

        # @return [Hash, nil]
        def encode_android_notification(v)
          return nil unless v
          unless v.is_a?(AndroidNotification)
            raise ArgumentError, "AndroidConfig.notification must be an AndroidNotification"
          end

          result = {
            body: check_string("AndroidNotification.body", v.body),
            body_loc_key: check_string("AndroidNotification.body_loc_key", v.body_loc_key),
            body_loc_args: check_string_array("AndroidNotification.body_loc_args", v.body_loc_args),
            click_action: check_string("AndroidNotification.click_action", v.click_action),
            color: check_color("AndroidNotification.color", v.color, allow_alpha: true, required: false),
            icon: check_string("AndroidNotification.icon", v.icon),
            sound: check_string("AndroidNotification.sound", v.sound),
            tag: check_string("AndroidNotification.tag", v.tag),
            title: check_string("AndroidNotification.title", v.title),
            title_loc_key: check_string("AndroidNotification.title_loc_key", v.title_loc_key),
            title_loc_args: check_string_array("AndroidNotification.title_loc_args", v.title_loc_args),
            channel_id: check_string("AndroidNotification.channel_id", v.channel_id),
            image: check_string("AndroidNotification.image", v.image),
            ticker: check_string("AndroidNotification.ticker", v.ticker),
            sticky: v.sticky,
            event_time: check_time("AndroidNotification.event_time", v.event_time),
            local_only: v.local_only,
            notification_priority: check_string("AndroidNotification.priority", v.priority, non_empty: true),
            vibrate_timings: check_numeric_array("AndroidNotification.vibrate_timings", v.vibrate_timings),
            default_vibrate_timings: v.default_vibrate_timings,
            default_sound: v.default_sound,
            default_light_settings: v.default_light_settings,
            light_settings: encode_light_settings(v.light_settings),
            visibility: check_string("AndroidNotification.visibility", v.visibility, non_empty: true),
            notification_count: check_numeric("AndroidNotification.notification_count", v.notification_count)
          }
          result = remove_nil_values(result)

          if result.key?(:body_loc_args) && !result.key?(:body_loc_key)
            raise ArgumentError, "AndroidNotification.body_loc_key is required when specifying body_loc_args"
          elsif result.key?(:title_loc_args) && !result.key?(:title_loc_key)
            raise ArgumentError, "AndroidNotification.title_loc_key is required when specifying title_loc_args"
          end

          if (event_time = result[:event_time])
            event_time = event_time.dup.utc unless event_time.utc?
            result[:event_time] = event_time.strftime("%Y-%m-%dT%H:%M:%S.%6NZ")
          end

          if (priority = result[:notification_priority])
            unless %w[min low default high max].include?(priority)
              raise ArgumentError, "AndroidNotification.priority must be 'default', 'min', 'low', 'high' or 'max'."
            end
            result[:notification_priority] = "PRIORITY_#{priority.upcase}"
          end

          if (visibility = result[:visibility])
            unless %w[private public secret].include?(visibility)
              raise ArgumentError, "AndroidNotification.visibility must be 'private', 'public' or 'secret'"
            end
            result[:visibility] = visibility.upcase
          end

          if (vibrate_timings = result[:vibrate_timings])
            vibrate_timing_strings = vibrate_timings.map do |t|
              encode_duration("AndroidNotification.vibrate_timings", t)
            end
            result[:vibrate_timings] = vibrate_timing_strings
          end

          result
        end

        # @return [Hash, nil]
        def encode_android_fcm_options(v)
          return nil unless v
          unless v.is_a?(AndroidFCMOptions)
            raise ArgumentError, "AndroidConfig.fcm_options must be an AndroidFCMOptions"
          end
          result = {
            analytics_label: check_analytics_label("AndroidFCMOptions.analytics_label", v.analytics_label)
          }
          remove_nil_values(result)
        end

        # @return [String, nil]
        def encode_duration(label, value)
          return nil unless value
          raise ArgumentError, "#{label} must be a numeric duration in seconds" unless value.is_a?(Numeric)
          raise ArgumentError, "#{label} must not be negative" if value < 0
          to_seconds_string(value)
        end

        # @return [Hash, nil]
        def encode_light_settings(v)
          return nil unless v
          raise ArgumentError, "AndroidNotification.light_settings must be a LightSettings." unless v.is_a?(LightSettings)
          result = {
            color: encode_color("LightSettings.color", v.color, allow_alpha: true),
            light_on_duration: encode_duration("LightSettings.light_on_duration", v.light_on_duration),
            light_off_duration: encode_duration("LightSettings.light_off_duration", v.light_off_duration)
          }
          result = remove_nil_values(result)
          unless result.key?(:light_on_duration)
            raise ArgumentError, "LightSettings.light_on_duration is required"
          end
          unless result.key?(:light_off_duration)
            raise ArgumentError, "LightSettings.light_off_duration is required"
          end
          result
        end

        # @return [Hash]
        def encode_color(label, value, allow_alpha: false)
          value = check_color(label, value, allow_alpha: allow_alpha, required: true)
          value += "FF" if value&.length == 7
          r = value[1..2].to_i(16) / 255.0
          g = value[3..4].to_i(16) / 255.0
          b = value[5..6].to_i(16) / 255.0
          a = value[7..8].to_i(16) / 255.0
          {red: r, green: g, blue: b, alpha: a}
        end

        # @return [Hash, nil]
        def encode_apns(apns)
          return nil unless apns
          raise ArgumentError, "Message.apns must be an APNSConfig" unless apns.is_a?(APNSConfig)
          result = {
            headers: check_string_hash("APNSConfig.headers", apns.headers),
            payload: encode_apns_payload(apns.payload),
            fcm_options: encode_apns_fcm_options(apns.fcm_options)
          }
          remove_nil_values(result)
        end

        # @return [Hash, nil]
        def encode_apns_payload(payload)
          return nil unless payload
          raise ArgumentError, "APNSConfig.payload must be an APNSPayload" unless payload.is_a?(APNSPayload)
          result = {
            aps: encode_aps(payload.aps)
          }
          payload.data&.each do |k, v|
            result[k] = v
          end
          remove_nil_values(result)
        end

        # @return [Hash, nil]
        def encode_apns_fcm_options(options)
          return nil unless options
          raise ArgumentError, "APNSConfig.fcm_options must be an APNSFCMOptions" unless options.is_a?(APNSFCMOptions)
          result = {
            analytics_label: check_analytics_label("APNSFCMOptions.analytics_label", options.analytics_label),
            image: check_string("APNSFCMOptions.image", options.image)
          }
          remove_nil_values(result)
        end

        # @return [Hash]
        def encode_aps(aps)
          raise ArgumentError, "APNSPayload.aps is required" unless aps
          raise ArgumentError, "APNSPayload.aps must be an APS" unless aps.is_a?(APS)
          result = {
            alert: encode_aps_alert(aps.alert),
            badge: check_numeric("APS.badge", aps.badge),
            sound: encode_aps_sound(aps.sound),
            category: check_string("APS.category", aps.category),
            "thread-id": check_string("APS.thread_id", aps.thread_id)
          }

          result[:"content-available"] = 1 if aps.content_available
          result[:"mutable-content"] = 1 if aps.mutable_content

          if (custom_data = aps.custom_data)
            raise ArgumentError, "APS.custom_data must be a hash" unless custom_data.is_a?(Hash)
            custom_data.each do |k, v|
              unless k.is_a?(String) || k.is_a?(Symbol)
                raise ArgumentError, "APS.custom_data key #{k}, must be a string or symbol"
              end
              k = k.to_sym
              raise ArgumentError, "Multiple specifications for #{k} in APS" if result.key?(k)
              result[k] = v
            end
          end

          remove_nil_values(result)
        end

        # @return [Hash, String, nil]
        def encode_aps_alert(alert)
          return nil unless alert
          return alert if alert.is_a?(String)
          raise ArgumentError, "APS.alert must be a string or an an APSAlert" unless alert.is_a?(APSAlert)

          result = {
            title: check_string("APSAlert.title", alert.title),
            subtitle: check_string("APSAlert.subtitle", alert.subtitle),
            body: check_string("APSAlert.body", alert.body),
            "title-loc-key": check_string("APSAlert.title_loc_key", alert.title_loc_key),
            "title-loc-args": check_string_array("APSAlert.title_loc_args", alert.title_loc_args),
            "subtitle-loc-key": check_string("APSAlert.subtitle_loc_key", alert.subtitle_loc_key),
            "subtitle-loc-args": check_string_array("APSAlert.subtitle_loc_args", alert.subtitle_loc_args),
            "loc-key": check_string("APSAlert.loc_key", alert.loc_key),
            "loc-args": check_string_array("ASPAlert.loc_args", alert.loc_args),
            "action-loc-key": check_string("APSAlert.action_loc_key", alert.action_loc_key),
            "launch-image": check_string("APSAlert.launch_image", alert.launch_image)
          }
          result = remove_nil_values(result)

          if result.key?(:"loc-args") && !result.key?(:"loc-key")
            raise ArgumentError, "APSAlert.loc_key is required when specifying loc_args"
          elsif result.key?(:"title-loc-args") && !result.key?(:"title-loc-key")
            raise ArgumentError, "APSAlert.title_loc_key is required when specifying title_loc_args"
          elsif result.key?(:"subtitle-loc-args") && !result.key?(:"subtitle-loc-key")
            raise ArgumentError, "APSAlert.subtitle_loc_key is required when specifying subtitle_loc_args"
          end

          if (custom_data = alert.custom_data)
            raise ArgumentError, "APSAlert.custom_data must be a hash" unless custom_data.is_a?(Hash)
            custom_data.each do |k, v|
              unless k.is_a?(String) || k.is_a?(Symbol)
                raise ArgumentError, "APSAlert.custom_data key #{k}, must be a string or symbol"
              end
              k = k.to_sym
              result[k] = v
            end
          end
          remove_nil_values(result)
        end

        # @return [Hash, String, nil]
        def encode_aps_sound(sound)
          return nil unless sound
          return sound if sound.is_a?(String) && !sound.empty?
          unless sound.is_a?(CriticalSound)
            raise ArgumentError, "APS.sound must be a non-empty string or a CriticalSound"
          end

          result = {
            name: check_string("CriticalSound.name", sound.name, non_empty: true),
            volume: check_numeric("CriticalSound.volume", sound.volume)
          }

          result[:critical] = 1 if sound.critical
          raise ArgumentError, "CriticalSound.name is required" if result[:name].nil?

          if (volume = result[:volume])
            raise ArgumentError, "CriticalSound.volume must be between [0,1]." unless volume >= 0 && volume <= 1
          end

          remove_nil_values(result)
        end

        # @return [Hash, nil]
        def encode_notification(v)
          return nil unless v
          raise ArgumentError, "Message.notification must be a Notification" unless v.is_a?(Notification)
          result = {
            body: check_string("Notification.body", v.body),
            title: check_string("Notification.title", v.title),
            image: check_string("Notification.image", v.image)
          }
          remove_nil_values(result)
        end

        # @return [Hash, nil]
        def encode_fcm_options(options)
          return nil unless options
          raise ArgumentError, "Message.fcm_options must be a FCMOptions." unless options.is_a?(FCMOptions)
          result = {
            analytics_label: check_analytics_label("Message.fcm_options", options.analytics_label)
          }
          remove_nil_values(result)
        end

        # Remove nil values and empty collections from the specified hash.
        # @return [Hash]
        def remove_nil_values(hash)
          hash.reject do |_, v|
            if v.is_a?(Hash) || v.is_a?(Array)
              v.empty?
            else
              v.nil?
            end
          end
        end

        include Utils
      end
    end
  end
end
