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
        URI.encode(path)
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

      # Returns the host of the UI
      def host
        @uri.host
      end

      # Returns path of the `Uri`, normalizes the path, and encode the path as
      # required by version 4
      def path
        uri = @uri.normalize
        path = uri.path.to_s
        path = "/" if path.blank?
        self.class.encode(path)
      end
    end
  end
end
