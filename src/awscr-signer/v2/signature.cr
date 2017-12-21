require "base64"

module Awscr
  module Signer::V2
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

      # Returns the signature in version 2 format
      def to_s(io : IO)
        io << Base64.strict_encode(HMAC.digest(@credentials.secret, @string, :sha1))
      end
    end
  end
end
