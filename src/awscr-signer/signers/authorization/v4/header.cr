module Awscr
  module Signer
    module Signers
      module Authorization::V4
        class Header
          def initialize(@scope : Scope, @credentials : Credentials)
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

            canonical_request = Signer::V4::Request.new(request.method,
              URI.parse(request.path), request.body)

            request.query_params.to_h.each do |k, v|
              canonical_request.query.add(k, v)
            end

            request.headers.each do |k, v|
              canonical_request.headers.add(Signer::Header.new(k, v))
            end

            content_length = request.headers["Content-Length"]?
            if content_length && content_length.to_i > 0
              request.headers["X-Amz-Content-Sha256"] =
                canonical_request.digest

              canonical_request.headers.add("X-Amz-Content-Sha256",
                canonical_request.digest)
            end

            signature = Signer::V4::Signature.new(@scope, canonical_request.to_s, @credentials)

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
end
