require "openssl"
require "openssl/digest"

module Awscr
  module Signer::V4
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

      # The computed digest of the request body
      getter digest

      # The request body
      getter body

      @path : String
      @digest : String
      @body : IO
      @query : QueryString
      @encode : Bool

      def initialize(@method : String, path : String, body : IO | String | Nil, @encode=true)
        @path = build_path(path)
        @query = QueryString.new
        @headers = HeaderCollection.new
        @body = build_body(body)
        @digest = build_body_digest
      end

      def host
        @headers["Host"]?.try(&.value)
      end

      # Returns the request as a String.
      def to_s(io : IO)
        io << [
          @method,
          @path,
          query,
          headers,
          @headers.keys.join(";"),
          @digest,
        ].map(&.to_s).join("\n")
      end

      private def build_body_digest
        if body.to_s == "UNSIGNED-PAYLOAD"
          body.to_s
        else
          digest = OpenSSL::Digest.new("SHA256")

          buffer = uninitialized UInt8[1_048_576] # 1mb
          while (read_bytes = body.read(buffer.to_slice)) > 0
            digest << buffer.to_slice[0, read_bytes]
          end
          body.rewind

          digest.final.hexstring
        end
      end

      # Encodes the path except '/' and '~'
      def self.encode_path(path)
        String.build do |io|
          URI.encode(path, io) { |byte| URI.unreserved?(byte) || byte.chr == '/' || byte.chr == '~' }
        end
      end

      private def build_path(path)
        return "/" if path.blank?
        uri = URI.parse(path)
        raise Exception.new("You may not give a URI with query params, they are
                            ignored. Use #query object intead") unless uri.query.nil?

        path = uri.normalize.path
        if @encode
          self.class.encode_path(path)
        else
          path
        end
      end

      private def build_body(body)
        case body
        when IO
          body
        when String
          IO::Memory.new(body)
        when Nil
          IO::Memory.new("")
        else
          raise "Unsupported body type"
        end
      end
    end
  end
end
