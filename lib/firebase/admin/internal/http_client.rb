require "faraday"

module Firebase
  module Admin
    module Internal
      # A class to work with
      class HTTPClient
        # The admin sdk user agent.
        USER_AGENT = "Firebase/HTTP/#{VERSION}/#{RUBY_VERSION}/AdminRuby"

        def initialize(uri: nil, credentials: nil)
          @uri = uri ? Faraday::Utils::URI(uri) : nil
          @credentials = credentials
        end

        def head(url = nil, params = nil, headers = nil)
          connection.head(url, params, headers)
        end

        def get(url = nil, params = nil, headers = nil)
          connection.get(url, params, headers)
        end

        def delete(url = nil, params = nil, headers = nil)
          connection.delete(url, params, headers)
        end

        def trace(url = nil, params = nil, headers = nil)
          connection.trace(url, params, headers)
        end

        def put(url = nil, params = nil, headers = nil)
          connection.put(url, params, headers)
        end

        def post(url = nil, params = nil, headers = nil)
          connection.post(url, params, headers)
        end

        def patch(url = nil, params = nil, headers = nil)
          connection.patch(url, params, headers)
        end

        private

        # @return [Faraday::Connection]
        def connection
          options = {
            headers: {
              Accept: "application/json; charset=utf-8",
              "Content-Type": "application/json; charset=utf-8",
              "User-Agent": USER_AGENT
            }
          }

          @connection ||= Faraday::Connection.new(@uri, options) do |c|
            # c.use CredentialsMiddleware, credentials: @credentials unless @credentials.nil?
            c.request :url_encoded
            c.response :json
            c.response :raise_error
            c.adapter(Faraday.default_adapter)
          end
        end

        # TODO: extract it as a separate gem? or at least rewrite it.
        # Middleware for applying credentials to authenticate requests.
        # class CredentialsMiddleware < Faraday::Middleware
        #  def on_request(env)
        #    creds = options[:credentials]
        #    creds.apply!(env[:request_headers])
        #  end
        # end
        # private_constant :CredentialsMiddleware
      end
    end
  end
end
