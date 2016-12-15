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
      def initialize(request : Request, scope : Scope)
        @request = request
        @scope = scope
        @signature = Signature.new(@scope, @request.to_s)
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
          "Credential=#{@scope.credentials.key}/#{@scope.to_s}",
        ].join(" ")
      end
    end
  end
end
