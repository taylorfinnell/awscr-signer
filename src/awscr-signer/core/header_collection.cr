module Awscr
  module Signer
    # An array like structure that holds `Header` objects. Duplicated
    # headers are merged into a single header. The data structure maintains
    # proper ordering of the headers.
    #
    # ```
    # headers = HeaderCollection.new
    # headers.add(Header.new("k", "v"))
    # headers.to_a # => [Header.new("k", "v")]
    # ```
    class HeaderCollection
      include Enumerable(Header)

      # List of headers names not allowed in the collection.
      BLACKLIST_HEADERS = [
        "cache-control",
        "content-length",
        "expect",
        "max-forwards",
        "pragma",
        "te",
        "if-match",
        "if-none-match",
        "if-modified-since",
        "if-unmodified-since",
        "if-range",
        "accept",
        "authorization",
        "proxy-authorization",
        "from",
        "referer",
        "user-agent",
      ]

      @headers = [] of Header

      # Adds a header to the collection. Merging duplicate header keys
      # as per AWS requirements
      def add(k : String, v : String) : HeaderCollection
        add(Header.new(k, v))
      end

      # Deletes the header
      def delete(header : Header)
        @headers.delete(header)
      end

      # Deletes a header by a string
      def delete(key : String)
        delete(Header.new(key))
      end

      # Returns a list of the header keys ie: names
      def keys
        @headers.map(&.key)
      end

      # Get a header by key, or nil of it does not exit
      def []?(key) : (Header | Nil)
        @headers.find { |g| g == key }
      end

      # Set or add a header by key value
      def []=(key, value)
        add(Header.new(key, value))
      end

      # Adds a Header to the internal header list If the header already
      # exists, it's value is updated
      def add(header : Header) : HeaderCollection
        return self if BLACKLIST_HEADERS.includes?(header.key)

        conflict = @headers.index(header)

        if conflict.nil?
          @headers.push(header)
        else
          @headers[conflict].merge(header)
        end

        @headers.sort_by!(&.key)

        self
      end

      # Yields each header
      def each
        @headers.each { |header| yield header }
      end

      # Returns the collection of headers separated by newline with a trailing
      # new line added
      def to_s(io : IO)
        io << map(&.to_s).join("\n") + "\n"
      end
    end
  end
end
