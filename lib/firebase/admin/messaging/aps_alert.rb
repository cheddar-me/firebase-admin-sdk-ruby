module Firebase
  module Admin
    module Messaging
      # An alert that can be included in an {APS}.
      class APSAlert
        # @return [String, nil]
        #   Title of the alert. If specified, overrides the title set via {Notification}.
        attr_accessor :title

        # @return [String, nil]
        #   Subtitle of the alert.
        attr_accessor :subtitle

        # @return [String, nil]
        #   Body of the alert. If specified, overrides the body set via {Notification}.
        attr_accessor :body

        # @return [String, nil]
        #   Key of the body string in the app's string resources to use to localize the body text.
        attr_accessor :loc_key

        # @return [Array<String>, nil]
        #   A list of resource keys that will be used in place of the format specifiers in {loc_key}.
        attr_accessor :loc_args

        # @return [String, nil]
        #   Key of the title string in the app's string resources to use to localize the title text.
        attr_accessor :title_loc_key

        # @return [Array<String>, nil]
        #   A list of resource keys that will be used in place of the format specifiers in {title_loc_key}.
        attr_accessor :title_loc_args

        # @return [String, nil]
        #   Key of the subtitle string in the app's string resources to use to localize the subtitle text.
        attr_accessor :subtitle_loc_key

        # @return [Array<String>, nil]
        #   A list of resource keys that will be used in place of the format specifiers in {subtitle_loc_key}.
        attr_accessor :subtitle_loc_args

        # @return [String, nil]
        #   Key of the text in the app's string resources to use to localize the action button text.
        attr_accessor :action_loc_key

        # @return [String, nil]
        #   Image for the notification action.
        attr_accessor :launch_image

        # @return [Hash, nil]
        #   A Hash of custom key-value pairs to be included in the {APSAlert}
        attr_accessor :custom_data

        # Initializes an {APSAlert}.
        #
        # @param [String, nil] title
        #   Title of the alert (optional). If specified, overrides the title set via {Notification}.
        # @param [String, nil] subtitle
        #   Subtitle of the alert (optional).
        # @param [String, nil] body
        #   Body of the alert (optional). If specified, overrides the body set via {Notification}.
        # @param [String, nil] loc_key
        #   Key of the body string in the app's string resources to use to localize the body text (optional).
        # @param [Array<String>, nil] loc_args
        #   List of resource keys that will be used in place of the format specifiers in {loc_key} (optional).
        # @param [String, nil] title_loc_key
        #   Key of the title string in the app's string resources to use to localize the title text (optional).
        # @param [Array<String>, nil] title_loc_args
        #   List of resource keys that will be used in place of the format specifiers in {title_loc_key} (optional).
        # @param [String, nil] subtitle_loc_key
        #   Key of the subtitle string in the app's string resources to use to localize the subtitle text (optional).
        # @param [Array<String>, nil] subtitle_loc_args
        #   List of resource keys that will be used in place of the format specifiers in {subtitle_loc_key} (optional).
        # @param [String, nil] action_loc_key
        #   Key of the text in the app's string resources to use to localize the action button text (optional).
        # @param [String, nil] launch_image
        #   Image for the notification action (optional).
        # @param [Hash, nil] custom_data
        #   A Hash of custom key-value pairs to be included in the {APSAlert} (optional).
        def initialize(
          title: nil,
          subtitle: nil,
          body: nil,
          loc_key: nil,
          loc_args: nil,
          title_loc_key: nil,
          title_loc_args: nil,
          subtitle_loc_key: nil,
          subtitle_loc_args: nil,
          action_loc_key: nil,
          launch_image: nil,
          custom_data: nil
        )
          self.title = title
          self.subtitle = subtitle
          self.body = body
          self.loc_key = loc_key
          self.loc_args = loc_args
          self.title_loc_key = title_loc_key
          self.title_loc_args = title_loc_args
          self.subtitle_loc_key = subtitle_loc_key
          self.subtitle_loc_args = subtitle_loc_args
          self.action_loc_key = action_loc_key
          self.launch_image = launch_image
          self.custom_data = custom_data
        end
      end
    end
  end
end
