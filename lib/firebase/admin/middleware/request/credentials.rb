require "faraday/middleware"

# Middleware for applying credentials to authenticate requests.
module Faraday
  module Credentials
    class Middleware < ::Faraday::Middleware
      def on_request(env)
        creds = options[:credentials]
        creds.apply!(env[:request_headers])
      end
    end
  end
end

Faraday::Request.register_middleware(credentials: Faraday::Credentials::Middleware)
