require "uri"

module Awscr
  module Signer
    # A Uri
    #
    # ```
    # uri = Uri.new(::URI.parse("/"))
    # uri.to_s
    # ```
    class Uri
      def self.encode(path : String)
        URI.escape(path) { |byte| URI.unreserved?(byte) || byte.chr == '/' }
      end

      # The path must be non encoded.
      def initialize(path : String)
        @path = path
      end

      # The path must be non encoded.
      def initialize(uri : URI)
        @path = uri.path.to_s
      end

      # Returns the uri encoded
      def to_s
        # Allows input of /test ing/ and /test%20ing/
        uri = URI.parse(@path)
        path = uri.path.to_s
        path = "/" if path.blank?
        self.class.encode(path)
      end
    end
  end
end
