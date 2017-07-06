module Awscr
  module Signer
    module Presigned
      class Url
        @expires : Int32

        def initialize(@object : String, @bucket : String,
                       @scope : Scope, @credentials : Credentials, @expires = 86_400)
        end

        def get
          request("GET")
        end

        def put
          request("PUT")
        end

        private def request(method)
          cred_scope = CredentialScope.new(@credentials, @scope)

          request = Request.new(method.upcase, URI.parse("https://#{@bucket}.s3.amazonaws.com#{@object}"), "UNSIGNED-PAYLOAD")
          request.headers.add("Host", "#{@bucket}.s3.amazonaws.com")

          request.query.add("X-Amz-Algorithm", "AWS4-HMAC-SHA256")
          request.query.add("X-Amz-Credential", cred_scope.to_s)
          request.query.add("X-Amz-Date", @scope.date.iso8601)
          request.query.add("X-Amz-Expires", @expires.to_s)
          request.query.add("X-Amz-SignedHeaders", "host")

          sig = Signature.new(@scope, request, @credentials)

          # the full path of the request, plus the calculated sig
          "#{request.full_path}&X-Amz-Signature=#{sig.to_s}"
        end
      end
    end
  end
end
