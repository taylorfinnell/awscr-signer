require "http/request"

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

        def initialize(@service : String, @region : String, @aws_access_key : String, @aws_secret_key : String, @amz_security_token : String? = nil)
          @credentials = Signer::Credentials.new(aws_access_key, aws_secret_key)
        end

        def sign(string : String)
          scope = Signer::Scope.new(@region, @service)
          sig = Signer::V4::Signature.new(scope, string, @credentials, compute_digest: false)
          sig.to_s
        end

        # Sign an HTTP::Request
        def sign(request : HTTP::Request, add_sha = true, encode_path = true)
          header_impl(request, add_sha, encode_path)
        end

        def presign(request, encode_path = true)
          querystring_impl(request, encode_path)
        end

        private def querystring_impl(request, encode_path)
          scope = Signer::Scope.new(@region, @service)
          request.query_params.add("X-Amz-Algorithm", Signer::ALGORITHM)
          request.query_params.add("X-Amz-Credential", "#{@credentials.key}/#{scope}")
          request.query_params.add("X-Amz-Date", scope.date.iso8601)

          canonical_request = Signer::V4::Request.new(request.method,
            request.path, request.body, encode_path)

          request.query_params.to_h.each do |k, v|
            canonical_request.query.add(k, v)
          end

          request.headers.each do |k, v|
            canonical_request.headers.add(Signer::Header.new(k, v))
          end

          canonical_request.query.add("X-Amz-SignedHeaders", "#{canonical_request.headers.keys.join(";")}")

          signature = Signer::V4::Signature.new(scope, canonical_request.to_s, @credentials)
          request.query_params.add("X-Amz-SignedHeaders", "#{canonical_request.headers.keys.join(";")}")
          request.query_params.add("X-Amz-Signature", signature.to_s)
        end

        private def header_impl(request, add_sha, encode_path)
          scope = Signer::Scope.new(@region, @service)

          @amz_security_token.try do |token|
            request.headers["X-Amz-Security-Token"] = token
          end
          # Replace "Date" with X-Amz-Date.
          # Only if X-Amz-Date is not already set. AWS prefers
          # X-Amz-Date
          if date = request.headers.delete("Date")
            request.headers["X-Amz-Date"] ||= date
          else
            # Default it to the given scope time, if not set
            request.headers["X-Amz-Date"] ||= scope.date.iso8601
          end

          canonical_request = Signer::V4::Request.new(request.method,
            request.path, request.body, encode_path)

          request.query_params.to_h.each do |k, v|
            canonical_request.query.add(k, v)
          end

          request.headers.each do |k, v|
            canonical_request.headers.add(Signer::Header.new(k, v))
          end

          if add_sha # amazon test suite does not inlcude this
            request.headers["X-Amz-Content-Sha256"] =
              canonical_request.digest

            canonical_request.headers.add("X-Amz-Content-Sha256",
              canonical_request.digest)
          end

          signature = Signer::V4::Signature.new(scope, canonical_request.to_s, @credentials)

          request.headers["Authorization"] = [
            [Signer::ALGORITHM, "Credential=#{@credentials.key}/#{scope}"].join(" "),
            "SignedHeaders=#{canonical_request.headers.keys.join(";")}",
            "Signature=#{signature}",
          ].join(", ")
        end
      end
    end
  end
end
