module Awscr
  module Signer
    # Represents a Header as defined by the signing spec.
    #
    # ```
    # header = Header.new("k", "v")
    # header.to_s # => k:v
    #
    # header.merge("value2")
    # header.to_s # => k:v,value2
    # ```
    class Header
      include Comparable(Header)
      include Comparable(String)

      @values = [] of String

      def initialize(key : String)
        @key = HeaderKey.new(key)
        @value = HeaderValue.new("")
      end

      # Create a header from a string key and string value
      def initialize(key : String, value : (Array(String) | String))
        @key = HeaderKey.new(key)
        @value = HeaderValue.new(value)
      end

      # Merges a header into the current header values
      def merge(hdr : Header) : Bool
        merge(hdr.value)
      end

      # Merges a value into the header's values
      def merge(value : String) : Bool
        @value.merge(value)
      end

      # Returns the key as a string.
      def key : String
        @key.to_s
      end

      # Returns the value as a string.
      def value : String
        @value.to_s
      end

      # Return the canonical string representation
      def to_s(io : IO)
        io << "#{key}:#{value}"
      end

      def <=>(header : Header) : Int
        header.key <=> key
      end

      def <=>(string : String) : Int
        Header.new(string, "") <=> self
      end
    end
  end
end
