require "http/request"
require "./authorization/v4/*"

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
        include Interface

        def initialize(service : String, region : String, aws_access_key : String, aws_secret_key : String)
          @scope = Signer::Scope.new(region, service)
          @credentials = Signer::Credentials.new(aws_access_key, aws_secret_key)
        end

        def sign(str : String)
          authorization = Authorization::V4::PlainText.new(@scope, @credentials)
          authorization.sign(str)
        end

        # Sign an HTTP::Request
        def sign(request : HTTP::Request)
          strategy = Authorization::V4::Header.new(@scope, @credentials)
          strategy.sign(request)
        end

        def presign(request)
          strategy = Authorization::V4::QueryString.new(@scope, @credentials)
          strategy.sign(request)
        end
      end
    end
  end
end
