require "uri"

module Awscr
  module Signer::V4
    # A Uri
    #
    # ```
    # uri = Uri.new(::URI.parse("/"))
    # uri.path
    # ```
    class Uri
      @uri : URI

      @query = QueryString.new

      def self.encode(path : String)
        URI.escape(path) { |byte| URI.unreserved?(byte) || byte.chr == '/' }
      end

      # The path must be non encoded.
      def initialize(path : String)
        @uri = URI.parse(path)
      end

      # The path must be non encoded.
      def initialize(@uri : URI)
      end

      # Returns the uri encoded
      def to_s(io : IO)
        scheme = @uri.scheme ? @uri.scheme : "http"
        io << "#{scheme}://#{@uri.host}#{@uri.path}"
      end

      def host
        @uri.host
      end

      def path
        # Allows input of /test ing/ and /test%20ing/
        uri = URI.parse(@uri.path.to_s).normalize
        path = uri.path.to_s
        path = "/" if path.blank?
        self.class.encode(path)
      end
    end
  end
end
