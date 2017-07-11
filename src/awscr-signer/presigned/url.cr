module Awscr
  module Signer
    module Presigned
      class Url
        struct Options
          getter bucket
          getter object
          getter expires
          getter additional_options

          @expires : Int32
          @additional_options : Hash(String, String)
          @bucket : String
          @object : String

          def initialize(@object, @bucket, @expires = 86_400,
                         @additional_options = {} of String => String)
          end
        end

        def initialize(@scope : Scope, @credentials : Credentials, @options : Options)
        end

        def for(method)
          raise "unsupported method #{method}" unless allowed_methods.includes?(method)

          headers = HTTP::Headers.new
          headers.add("Host", "s3.amazonaws.com")

          request = HTTP::Request.new(method.to_s.upcase,
            "/#{@options.bucket}#{@options.object}",
            headers,
            "UNSIGNED-PAYLOAD")

          request.query_params.add("X-Amz-Expires", @options.expires.to_s)

          @options.additional_options.each do |k, v|
            request.query_params.add(k, v)
          end

          signer = Signers::V4.new(@scope, @credentials)
          signer.presign(request)

          String.build do |str|
            str << "https://"
            str << request.host
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
