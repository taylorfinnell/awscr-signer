require "http/request"

module Awscr
  module Signer
    module Signers
      class V2
        include Interface

        def initialize(@service : String, @region : String, @aws_access_key : String, @aws_secret_key : String)
          @credentials = Signer::Credentials.new(aws_access_key, aws_secret_key)
        end

        def sign(string : String)
          scope = Signer::Scope.new(@region, @service)
          sig = Signer::V2::Signature.new(scope, string, @credentials)
          sig.to_s
        end

        # Sign an HTTP::Request
        def sign(request : HTTP::Request)
          scope = Signer::Scope.new(@region, @service)

          # Replace "Date" with X-Amz-Date.
          # Only if X-Amz-Date is not already set. AWS prefers
          # X-Amz-Date
          if date = request.headers.delete("X-Amz-Date")
            request.headers["Date"] ||= date
          else
            # Default it to the given scope time, if not set
            request.headers["Date"] ||= scope.date.rfc1123z
          end

          canonical_request = Signer::V2::Request.new(request.method,
            URI.parse(request.path), request.body)

          request.query_params.to_h.each do |k, v|
            canonical_request.query_params.add(k, v)
          end

          request.headers.each do |k, v|
            canonical_request.headers.add(Signer::Header.new(k, v))
          end

          signature = Signer::V2::Signature.new(scope, canonical_request.to_s, @credentials)

          request.headers["Authorization"] = [
            "AWS ", @credentials.key, ":", signature,
          ].join
        end

        def presign(request, expires = nil)
          scope = Signer::Scope.new(@region, @service)

          expires ||= Time.utc.to_unix + 86_400

          canonical_request = Signer::V2::Request.new(request.method,
            URI.parse(request.path), request.body)

          request.query_params.to_h.each do |k, v|
            canonical_request.query_params.add(k, v)
          end

          request.headers.each do |k, v|
            canonical_request.headers.add(Signer::Header.new(k, v))
          end

          signature = Signer::V2::Signature.new(scope, canonical_request.to_s, @credentials)

          request.query_params.add("AWSAccessKeyId", @credentials.key)
          request.query_params.add("Signature", signature.to_s)
        end
      end
    end
  end
end
