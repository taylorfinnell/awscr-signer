module Awscr
  module Signer
    # Compute a lower(hex(sha256(x))) digest for a given string.
    #
    # ```
    # SHA256.digest("test")
    # ```
    class SHA256
      INSTANCE = SHA256.new

      # Compute the digest for a given string
      def self.digest(str)
        INSTANCE.digest(str)
      end

      # Computes the digest for a given string
      def digest(string)
        digest.tap { |digest| digest << string }.hexdigest
      end

      # :nodoc:
      private def digest
        OpenSSL::Digest.new("SHA256")
      end
    end
  end
end
