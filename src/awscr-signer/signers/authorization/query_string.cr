module Awscr
  module Signer
    module Signers
      module Authorization
        class QueryString
          def initialize(@scope : Scope, @credentials : Credentials)
          end

          def sign(request)
            request.query_params.add("X-Amz-Algorithm", Signer::ALGORITHM)
            request.query_params.add("X-Amz-Credential", "#{@credentials.key}/#{@scope.to_s}")
            request.query_params.add("X-Amz-Date", @scope.date.iso8601)

            canonical_request = Signer::V4::Request.new(request.method,
              URI.parse(request.path), request.body)

            request.query_params.to_h.each do |k, v|
              canonical_request.query.add(k, v)
            end

            request.headers.each do |k, v|
              canonical_request.headers.add(Signer::Header.new(k, v))
            end

            canonical_request.query.add("X-Amz-SignedHeaders", "#{canonical_request.headers.keys.join(";")}")

            signature = Signer::V4::Signature.new(@scope, canonical_request.to_s, @credentials)
            request.query_params.add("X-Amz-SignedHeaders", "#{canonical_request.headers.keys.join(";")}")
            request.query_params.add("X-Amz-Signature", signature.to_s)
          end
        end
      end
    end
  end
end
