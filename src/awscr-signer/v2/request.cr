require "openssl"
require "openssl/digest"

module Awscr
  module Signer::V2
    class Request
      getter query_params
      getter headers

      def initialize(@method : String, @uri : URI, body : IO | String | Nil)
        @query_params = Signer::QueryString.new
        @headers = Signer::HeaderCollection.new
      end

      # Returns the canonical string to sign
      def to_s(io)
        io << String.build do |str|
          str << "#{@method}\n"
          str << "#{content_md5}\n"
          str << "#{content_type}\n"
          if expires
            str << "#{expires}\n"
          else
            str << "#{date}\n"
          end
          str << canonical_amz_headers
          str << canonical_resource_element
        end
      end

      def host
        if host = @headers["Host"]?
          # remove port
          host.value.split(":").first
        else
          nil
        end
      end

      private def expires
        @query_params.find { |k, v| k == "Expires" }.try(&.last)
      end

      # :nodoc:
      private def date
        (@headers["X-Amz-Date"]? || @headers["Date"]?).try(&.value)
      end

      # :nodoc:
      private def content_md5
        @headers["Content-MD5"]?.try(&.value)
      end

      # :nodoc:
      private def content_type
        @headers["Content-Type"]?.try(&.value)
      end

      # :nodoc:
      private def canonical_amz_headers
        @headers.select do |header|
          header.key =~ /x-amz-/ &&
            header.key != "x-amz-date"
        end.map(&.to_s).map { |x| x + "\n" }.join
      end

      # :nodoc:
      private def canonical_resource_element
        String.build do |str|
          if cname? && host
            str << "/"
            str << host if host
          elsif virtual_host?
            str << "/"
            str << host.to_s.split(".").first if host
          end

          str << @uri.path

          if !canonical_params.empty?
            str << "?"
            str << canonical_params
          end
        end
      end

      # :nodoc:
      private def canonical_params
        @query_params.select { |k, _| resources.includes?(k) }.sort.map do |k, v|
          v.empty? ? k : "#{k}=#{v}"
        end.join("&")
      end

      # :nodoc:
      private def resources
        %w(acl lifecycle location logging notification partNumber policy
          requestPayment torrent uploadId uploads versionId versioning versions
          website)
      end

      # :nodoc:
      private def virtual_host?
        host.to_s.split(".").size > 3
      end

      # :nodoc:
      private def cname?
        !host.to_s.includes?("amazonaws.com")
      end
    end
  end
end
