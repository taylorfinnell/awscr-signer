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
      def initialize(uri : URI)
        @uri = uri
      end

      # Returns the uri, escaped, if needed
      def to_s
        path = @uri.path.to_s
        if path == "/"
          "/"
        else
          "/" + URI.escape(path[1..-1])
        end
      end
    end
  end
end
