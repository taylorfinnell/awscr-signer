require "http/request"
require "./authorization/*"

module Awscr
  module Signer
    module Signers
      # Signs a Crystal HTTP::Request using a given scope.
      #
      # ```
      # scope = Awscr::Signer::Scope.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY",
      #   "us-east-1", "service", Time.now)
      # signer = Signer::V4.new(request, scope)
      # signer.sign
      # ```
      class V4
        def initialize(@scope : Scope, @credentials : Credentials)
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
