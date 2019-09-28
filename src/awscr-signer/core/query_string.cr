module Awscr
  module Signer
    # Represents a `QueryString`. When converted to a String the keys and values
    # are sorted and URI encoded.
    #
    # ```
    # qs = QueryString.new
    # qs.add("k", "v")
    # qs.to_s # => "k&v"
    # ```
    class QueryString
      include Enumerable({String, String})

      @kvs = {} of String => String

      def each
        @kvs.each do |k, v|
          yield({k, v})
        end
      end

      # Adds a key and value to the query string
      def add(k : String, v : String)
        @kvs[k] = v
      end

      # Returns the object as a string.
      def to_s(io : IO)
        io << @kvs.to_a.sort.map { |k, v| encoded_kv(k, v) }.join("&")
      end

      # :nodoc:
      private def encoded_kv(k, v)
        "#{URI.encode_www_form(k, space_to_plus: false)}=#{URI.encode_www_form(v, space_to_plus: false)}"
      end
    end
  end
end
