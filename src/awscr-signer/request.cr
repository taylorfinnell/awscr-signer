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

      def initialize(method : String, uri : URI, payload : String | Nil)
        @method = method
        @uri = Uri.new(uri)
        @query = QueryString.new
        @headers = HeaderCollection.new
        @payload = payload || ""
      end

      # Returns the request as a String.
      def to_s : String
        [
          @method,
          @uri,
          query,
          headers,
          @headers.keys.join(";"),
          SHA256.digest(@payload.to_s),
        ].map(&.to_s).join("\n")
      end
    end
  end
end
