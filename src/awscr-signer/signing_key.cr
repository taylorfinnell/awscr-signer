require "./scope"

module Awscr
  module Signer
    # Create a signing key for the Scope
    #
    # ```
    # scope = Scope.new(...)
    # key = SigningKey.new(scope)
    # key.to_s
    # ```
    class SigningKey
      def initialize(scope : Scope, credentials : Credentials)
        @scope = scope
        @credentials = credentials
      end

      # Return the canonical string representation of the signing key
      def to_s
        k_secret = "AWS4#{@credentials.secret}"
        k_date = HMAC.digest(k_secret, @scope.date.ymd)
        k_region = HMAC.digest(k_date, @scope.region)
        k_service = HMAC.digest(k_region, @scope.service)
        HMAC.digest(k_service, "aws4_request")
      end
    end
  end
end
