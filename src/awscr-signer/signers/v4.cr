require "http/request"
require "./authorization/*"

module Awscr
  module Signer
    module Signers
      # Signs a Crystal HTTP::Request using a given scope.
      #
      # ```
      # signer = Signer::V4.new("s3", "region", "key", "secret")
      # signer.sign(request)
      # signer.sign("some string")
      # signer.presign(request)
      # ```
      class V4
        def initialize(service : String, region : String, aws_access_key :
                       String, aws_secret_key : String)
          @scope = Signer::Scope.new(region, service)
          @credentials = Signer::Credentials.new(aws_access_key, aws_secret_key)
        end

        # Sign an HTTP::Request
        def sign(request : HTTP::Request, content_sha = true)
          strategy = AuthorizationHeaderStrategy.new(@scope, @credentials, content_sha)
          strategy.sign(request)
        end

        # Sign a plain string with the credentials
        def sign(string : String)
          strat = PlainTextStrategy.new(@scope, @credentials)
          strat.sign(string)
        end

        def presign(request, content_sha = true)
          strategy = AuthorizationQueryStringStrategy.new(@scope, @credentials)
          strategy.sign(request)
        end
      end
    end
  end
end
