module Awscr
  module Signer
    module Presigned
      class Url
        struct Options
          getter bucket
          getter object
          getter expires
          getter additional_headers

          @expires : Int32
          @additional_headers : Hash(String, String)
          @bucket : String
          @object : String

          def initialize(@object, @bucket, @expires = 86_400,
                         @additional_headers = {} of String => String)
          end
        end

        def initialize(@scope : Scope, @credentials : Credentials, @options : Options)
        end

        def for(method)
          raise "unsupported method #{method}" unless allowed_methods.includes?(method)

          headers = HTTP::Headers.new
          headers.add("Host", "#{@options.bucket}.s3.amazonaws.com")

          request = HTTP::Request.new(method.to_s.upcase,
            "https://#{@options.bucket}.s3.amazonaws.com#{@options.object}",
            headers,
            "UNSIGNED-PAYLOAD")

          request.query_params.add("X-Amz-Expires", @options.expires.to_s)

          @options.additional_headers.each do |k, v|
            request.headers.add(k, v)
          end

          signer = Signers::V4.new(@scope, @credentials)
          signer.presign(request)

          String.build do |str|
            str << "https://"
            str << request.host_with_port
            str << request.resource
          end
        end

        private def allowed_methods
          [:get, :put]
        end
      end
    end
  end
end
