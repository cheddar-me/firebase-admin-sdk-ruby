require "addressable/uri"
require "faraday"
require "faraday_middleware"

module Firebase
  module Admin
    # The admin sdk user agent.
    USER_AGENT = "Firebase/HTTP/#{VERSION}/#{RUBY_VERSION}/AdminRuby"

    # A client for performing authenticated http requests to the admin REST API.
    module Client
      # Perform an HTTP request
      def request(method, path, options)
        response = connection.send(method) do |request|
          case method
          when :post, :put
            request.path = Addressable::URI.escape(path)
            request.body = options.to_json unless options.empty?
          else
            request.url(Addressable::URI.escape(path), options)
          end
        end
        response.body
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

        Faraday::Connection.new(@base_url, options) do |c|
          c.use CredentialsMiddleware, credentials: @credentials
          c.use Faraday::Request::UrlEncoded
          c.use FaradayMiddleware::Mashify
          c.use Faraday::Response::ParseJson
          c.use Faraday::Response::RaiseError
          c.adapter(Faraday.default_adapter)
        end
      end

      # Middleware for applying credentials to authenticate requests.
      class CredentialsMiddleware < Faraday::Middleware
        def on_request(env)
          creds = options[:credentials]
          creds.apply!(env[:request_headers])
        end
      end
      private_constant :CredentialsMiddleware
    end
  end
end
