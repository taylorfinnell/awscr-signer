module Awscr
  module Signer
    # Calculates an AWS V4 signature for a given object using the provided
    # scope
    #
    # ```
    # scope = Scope.new(...)
    # sig = Signature.new(scope, "some string")
    # puts sig.to_s # => the signature of the string with the given scope
    #
    # scope = Scope.new(...)
    # sig = Signature.new(scope, Request.new(...))
    # puts sig.to_s # => the signature of the `Request`
    # ```
    class Signature
      def initialize(scope : Scope, string : String, credentials : Credentials,
                    @compute_digest = true)
        @scope = scope
        @credentials = credentials
        @string = string
      end

      def initialize(scope : Scope, request : Request, credentials :
                     Credentials, @compute_digest = true)
        @scope = scope
        @credentials = credentials
        @string = request.to_s
      end

      # Compute the digest of the signing key and the string we are signing.
      # Returns the digest as a downcased hex string
      def to_s
        HMAC.hexdigest(signing_key, string_to_sign)
      end

      private def string_to_sign
        if @compute_digest
          [
            Signer::ALGORITHM,
            @scope.date.iso8601,
            @scope,
            digest
          ].map(&.to_s).join("\n")
        else
          @string
        end
      end

      private def digest
        digest = OpenSSL::Digest.new("SHA256")
        digest.update(@string)
        digest.hexdigest
      end

      # :nodoc:
      private def signing_key
        k_secret = "AWS4#{@credentials.secret}"
        k_date = HMAC.digest(k_secret, @scope.date.ymd)
        k_region = HMAC.digest(k_date, @scope.region)
        k_service = HMAC.digest(k_region, @scope.service)
        HMAC.digest(k_service, "aws4_request")
      end
    end
  end
end
