module MessagingHelper
  # @return [WebMock::RequestStub]
  def stub_send_request(file, response_hashes = {})
    stub_request(:post, "https://fcm.googleapis.com/v1/projects/test-adminsdk-project/messages:send").to_return(
      {
        status: 200,
        body: fixture(file),
        headers: {content_type: "application/json; charset=utf-8"}
      }.merge(response_hashes)
    )
  end

  def stub_topic_request(operation, file)
    stub_request(:post, "https://iid.googleapis.com/iid/v1:#{operation}").to_return(
      {
        status: 200,
        body: fixture(file),
        headers: {content_type: "application/json; charset=utf-8"}
      }
    )
  end
end
