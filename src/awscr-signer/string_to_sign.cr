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
      def initialize(scope : Scope, string : String, @raw = false)
        @string = string
        @scope = scope
      end

      # The raw `String` that will be signed.
      def raw
        @string
      end

      # Canonical string representation
      def to_s
        return raw if @raw

        [
          Signer::ALGORITHM,
          @scope.date.iso8601,
          @scope,
          digest,
        ].map(&.to_s).join("\n")
      end

      private def digest
        digest = OpenSSL::Digest.new("SHA256")
        digest.update(@string)
        digest.hexdigest
      end
    end
  end
end
