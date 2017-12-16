require "openssl/hmac"

module Awscr
  module Signer
    # Compute the HMAC digest
    #
    # ```
    # HMAC.digest("test", "test")
    # ```
    class HMAC
      INSTANCE = HMAC.new

      def self.digest(key : (String | Slice(UInt8)), data : String)
        INSTANCE.digest(key, data)
      end

      def self.hexdigest(key : (String | Slice(UInt8)), data : String)
        INSTANCE.hexdigest(key, data)
      end

      def hexdigest(key : String, data : String)
        OpenSSL::HMAC.hexdigest(:sha256, key, data)
      end

      def hexdigest(key : Slice(UInt8), data : String)
        OpenSSL::HMAC.hexdigest(:sha256, key, data)
      end

      def digest(key : String, data : String)
        OpenSSL::HMAC.digest(:sha256, key, data)
      end

      def digest(key : Slice(UInt8), data : String)
        OpenSSL::HMAC.digest(:sha256, key, data)
      end
    end
  end
end
