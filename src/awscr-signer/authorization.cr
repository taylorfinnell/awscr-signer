module Awscr
  module Signer
    # Represents the value that can be used as a valid
    # HTTP Authorization header.
    #
    # ```
    # authorization = Authorization.new(Request.new(...), Scope.new(...))
    # authorization.to_s
    # ```
    class Authorization
      def initialize(request : Request, scope : Scope, credentials : Credentials)
        @request = request
        @scope = scope
        @credentials = credentials
        @signature = Signature.new(@scope, @request.to_s, @credentials)
      end

      # The canonical authorization string. Suitable for use in an HTTP request.
      def to_s
        [credentials, signed_headers, signature].join(", ")
      end

      # :nodoc:
      private def signature
        "Signature=#{@signature.to_s}"
      end

      # :nodoc:
      private def signed_headers
        "SignedHeaders=#{@request.headers.keys.join(";")}"
      end

      # :nodoc:
      private def credentials
        [
          Signer::ALGORITHM,
          "Credential=#{@credentials.key}/#{@scope.to_s}",
        ].join(" ")
      end
    end
  end
end
