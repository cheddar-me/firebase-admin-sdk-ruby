module AuthHelper
  # @return [WebMock::RequestStub]
  def stub_auth_request(method, path)
    uri = "#{Firebase::Admin::Auth::ID_TOOLKIT_URL}/projects/test-adminsdk-project#{path}"
    stub_request(method, uri)
  end

  class ::FakeCredentials < Firebase::Admin::Credentials
    def apply!(hash, opts = {})
      hash
    end

    def self.from_file(file)
      creds = Firebase::Admin::Credentials.from_file(file)
      FakeCredentials.new(creds.credentials)
    end
  end
end
