describe Firebase::Admin::Messaging::MulticastMessage do
  describe "#initialize" do
    context "given no parameters" do
      it "should return a message object" do
        message = Firebase::Admin::Messaging::MulticastMessage.new
        expect(message).to have_attributes(
          data: nil,
          notification: nil,
          android: nil,
          apns: nil,
          fcm_options: nil,
          tokens: nil,
          topic: nil,
          condition: nil
        )
      end
    end
  end
end
