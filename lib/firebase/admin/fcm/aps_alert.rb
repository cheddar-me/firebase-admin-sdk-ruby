module Firebase
  module Admin
    module FCM
      # An alert that can be included in an {APS}.
      #
      # @!attribute title
      #   @return [String, nil]
      #     Title of the alert. If specified, overrides the title set via {Notification}.
      #
      # @!attribute subtitle
      #   @return [String, nil]
      #     Subtitle of the alert.
      #
      # @!attribute body
      #   @return [String, nil]
      #     Body of the alert. If specified, overrides the body set via {Notification}.
      #
      # @!attribute loc_key
      #   @return [String, nil]
      #     Key of the body string in the app's string resources to use to localize the body text.
      #
      # @!attribute loc_args
      #   @return [Array<String>, nil]
      #     A list of resource keys that will be used in place of the format specifiers in {loc_key}.
      #
      # @!attribute title_loc_key
      #   @return [String, nil]
      #     Key of the title string in the app's string resources to use to localize the title text.
      #
      # @!attribute title_loc_args
      #   @return [Array<String>, nil]
      #     A list of resource keys that will be used in place of the format specifiers in {title_loc_key}.
      #
      # @!attribute subtitle_loc_key
      #   @return [String, nil]
      #     Key of the subtitle string in the app's string resources to use to localize the subtitle text.
      #
      # @!attribute subtitle_loc_args
      #   @return [Array<String>, nil]
      #     A list of resource keys that will be used in place of the format specifiers in {subtitle_loc_key}.
      #
      # @!attribute action_loc_key
      #   @return [String, nil]
      #     Key of the text in the app's string resources to use to localize the action button text.
      #
      # @!attribute launch_image
      #   @return [String, nil]
      #     Image for the notification action.
      #
      # @!attribute custom_data
      #   @return [Hash, nil]
      #     A Hash of custom key-value pairs to be included in the {APSAlert}
      APSAlert = Struct.new(
        :title,
        :subtitle,
        :body,
        :loc_key,
        :loc_args,
        :title_loc_key,
        :title_loc_args,
        :subtitle_loc_key,
        :subtitle_loc_args,
        :action_loc_key,
        :launch_image,
        :custom_data,
        keyword_init: true
      )
    end
  end
end
