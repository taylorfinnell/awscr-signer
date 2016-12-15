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
      @kvs = {} of String => String

      # Adds a key and value to the query string
      def add(k : String, v : String)
        @kvs[k] = v
      end

      # Returns the object as a string.
      def to_s : String
        @kvs.to_a.sort.map { |k, v| encoded_kv(k, v) }.join("&")
      end

      # :nodoc:
      private def encoded_kv(k, v)
        "#{URI.escape(k)}=#{URI.escape(v)}"
      end
    end
  end
end
