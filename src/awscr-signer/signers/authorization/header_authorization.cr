module Awscr
  module Signer
    module Signers
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
    end
  end
end
