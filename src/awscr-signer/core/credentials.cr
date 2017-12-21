module Awscr
  module Signer
    # AWS access key and secret access key
    #
    # ```
    # credentials = Credentials.new("key", "secret")
    # credentials.to_s   # => "key:secret"
    # credentials.key    # => "key"
    # credentials.secret # => "secret"
    # ```
    class Credentials
      include Comparable(Credentials)

      # The AWS access key
      getter key

      # The AWS secret key
      getter secret

      def initialize(key : String, secret : String)
        @key = key
        @secret = secret
      end

      # Returns the object in a "key:secret" form
      def to_s(io : IO)
        io << "#{@key}:#{@secret}"
      end

      # Compare two `Credentials` object, returns true if equal, false
      # otherwise.
      def <=>(creds : Credentials)
        creds.to_s <=> to_s
      end
    end
  end
end
