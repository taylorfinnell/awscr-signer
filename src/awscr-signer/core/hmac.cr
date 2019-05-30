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

      def self.digest(key : (String | Slice(UInt8)), data : String, algorithm : OpenSSL::Algorithm = OpenSSL::Algorithm::SHA256)
        INSTANCE.digest(key, data, algorithm)
      end

      def self.hexdigest(key : (String | Slice(UInt8)), data : String, algorithm : OpenSSL::Algorithm = OpenSSL::Algorithm::SHA256)
        INSTANCE.hexdigest(key, data, algorithm)
      end

      def hexdigest(key : String, data : String, algorithm : OpenSSL::Algorithm)
        OpenSSL::HMAC.hexdigest(algorithm, key, data)
      end

      def hexdigest(key : Slice(UInt8), data : String, algorithm : OpenSSL::Algorithm)
        OpenSSL::HMAC.hexdigest(algorithm, key, data)
      end

      def digest(key : String, data : String, algorithm : OpenSSL::Algorithm)
        OpenSSL::HMAC.digest(algorithm, key, data)
      end

      def digest(key : Slice(UInt8), data : String, algorithm : OpenSSL::Algorithm)
        OpenSSL::HMAC.digest(algorithm, key, data)
      end
    end
  end
end
