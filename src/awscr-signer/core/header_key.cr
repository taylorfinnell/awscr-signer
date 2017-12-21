module Awscr
  module Signer
    # Represents the "key" of a `Header`. The `Header` key is what is used to
    # determine if two headers are the same.
    #
    # ```
    # key = HeaderKey.new("Test")
    # key.to_s # => "test"
    # ```
    class HeaderKey
      include Comparable(HeaderKey)

      # Create a key from a string
      def initialize(key : String)
        @key = key
      end

      # Returns the string form of the key
      def to_s(io : IO)
        io << @key.downcase
      end

      # Compare to another key
      def <=>(key : HeaderKey) : Int
        to_s <=> key.to_s
      end
    end
  end
end
