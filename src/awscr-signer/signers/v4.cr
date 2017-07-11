require "http/request"

module Awscr
  module Signer
    module Signers
      module AuthorizationStrategy
        abstract def sign(request : HTTP::Request)
      end

      class AuthorizationQueryStringStrategy
        include AuthorizationStrategy

        def initialize(@scope : Scope, @credentials : Credentials)
        end

        def sign(request)
          request.query_params.add("X-Amz-Algorithm", "AWS4-HMAC-SHA256")
          request.query_params.add("X-Amz-Credential", "#{@credentials.key}/#{@scope.to_s}")
          request.query_params.add("X-Amz-Date", @scope.date.iso8601)

          canonical_request = Request.new(request.method,
            URI.parse(request.path), request.body)

          request.query_params.to_h.each do |k, v|
            canonical_request.query.add(k, v)
          end

          request.headers.each do |k, v|
            canonical_request.headers.add(Header.new(k, v))
          end

          canonical_request.query.add("X-Amz-SignedHeaders", "#{canonical_request.headers.keys.join(";")}")

          signature = Signature.new(@scope, canonical_request.to_s, @credentials)
          request.query_params.add("X-Amz-SignedHeaders", "#{canonical_request.headers.keys.join(";")}")
          request.query_params.add("X-Amz-Signature", signature.to_s)
        end
      end

      class PlainTextStrategy
        include AuthorizationStrategy

        def initialize(@scope : Scope, @credentials : Credentials)
        end

        def sign(string)
          string_to_sign = StringToSign.new(@scope, string, raw: true)

          Signature.new(@scope, string_to_sign, @credentials)
        end
      end

      class AuthorizationHeaderStrategy
        include AuthorizationStrategy

        def initialize(@scope : Scope, @credentials : Credentials, @add_sha = true)
        end

        def sign(request : HTTP::Request)
          # Replace "Date" with X-Amz-Date.
          # Only if X-Amz-Date is not already set. AWS prefers
          # X-Amz-Date
          if date = request.headers.delete("Date")
            request.headers["X-Amz-Date"] ||= date
          else
            # Default it to the given scope time, if not set
            request.headers["X-Amz-Date"] ||= @scope.date.iso8601
          end

          canonical_request = Request.new(request.method,
            URI.parse(request.path), request.body)

          request.query_params.to_h.each do |k, v|
            canonical_request.query.add(k, v)
          end

          request.headers.each do |k, v|
            canonical_request.headers.add(Header.new(k, v))
          end

          if @add_sha
            request.headers["X-Amz-Content-Sha256"] = canonical_request.body

            canonical_request.headers.add("X-Amz-Content-Sha256",
              canonical_request.body)
          end

          signature = Signature.new(@scope, canonical_request.to_s, @credentials)

          request.headers["Authorization"] = [
            [Signer::ALGORITHM, "Credential=#{@credentials.key}/#{@scope.to_s}"].join(" "),
            "SignedHeaders=#{canonical_request.headers.keys.join(";")}",
            "Signature=#{signature.to_s}",
          ].join(", ")
        end
      end

      # Signer a Crystal HTTP::Request using a given scope.
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

        # Convert the HTTP::Request into a  request to figure out its
        # signature. Once the signature is calcualated add it to the original
        # HTTP::Request in the Authorization header, thus signing it.
        def sign(request, content_sha = true)
          strategy = AuthorizationHeaderStrategy.new(@scope, @credentials, content_sha)
          strategy.sign(request)
        end

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
