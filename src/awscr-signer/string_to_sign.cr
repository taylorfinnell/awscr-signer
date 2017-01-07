require "./scope"

module Awscr
  module Signer
    # A string that we can sign to form a `Signature`
    #
    # ```
    # sts = StringToSign.new(Scope.new(...), "test")
    # sts.to_s
    # ```
    class StringToSign
      def initialize(scope : Scope, string : String)
        @string = string
        @scope = scope
      end

      # The raw `String` that will be signed.
      def raw
        @string
      end

      # Canonical string representation
      def to_s
        [
          Signer::ALGORITHM,
          @scope.date.iso8601,
          @scope,
          SHA256.digest(@string),
        ].map(&.to_s).join("\n")
      end
    end
  end
end
