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
      def initialize(scope : Scope, string : String, credentials : Credentials)
        @scope = scope
        @credentials = credentials
        @string = string
      end

      def initialize(scope : Scope, request : Request, credentials : Credentials)
        @scope = scope
        @credentials = credentials
        @string = request.to_s
      end

      # Compute the digest of the signing key and the string we are signing.
      # Returns the digest as a downcased hex string
      def to_s
        HMAC.hexdigest(signing_key.to_s, string_to_sign.to_s)
      end

      # :nodoc:
      private def signing_key
        SigningKey.new(@scope, @credentials)
      end

      # :nodoc:
      private def string_to_sign
        StringToSign.new(@scope, @string)
      end
    end
  end
end
