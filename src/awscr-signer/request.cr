require "openssl"
require "openssl/digest"

module Awscr
  module Signer
    # Represents a request. It can have headers and query params.
    #
    # ```
    # request = Request.new("GET", URI.parse("/"), "")
    # request.headers.add(Header.new("k", "v"))
    # request.headers.to_a
    # request.params.add("k", "v")
    # request.to_s
    # ```
    class Request
      # The collection of `Header`s. Held in a
      # `HeaderCollection`
      getter headers

      # The collection of query string paramters. Held in a
      # `QueryString`
      getter query

      # The time of the request
      getter date

      @uri : Uri
      @body : String

      def initialize(method : String, uri : URI, body : IO | String | Nil)
        raise Exception.new("You may not give a URI with query params, they are
                            ignored. Use #query object intead") unless uri.query.nil?

        @method = method
        @uri = Uri.new(uri)
        @query = QueryString.new
        @headers = HeaderCollection.new

        if body.is_a?(IO)
          @body = body.gets_to_end
          body.rewind
        else
          @body = body.to_s
        end
      end

      def host
        @uri.host
      end

      def full_path
        "#{@uri.to_s}?#{query.to_s}"
      end

      # Returns the request as a String.
      def to_s
        [
          @method,
          @uri.path,
          query,
          headers,
          @headers.keys.join(";"),
          body,
        ].map(&.to_s).join("\n")
      end

      def body
        if @body == "UNSIGNED-PAYLOAD"
          @body
        else
          SHA256.digest(@body.to_s)
        end
      end
    end
  end
end
