require "http/request"

module Awscr
  module Signer
    # Signer a Crystal HTTP::Request using a given scope.
    #
    # ```
    # scope = Awscr::Signer::Scope.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY",
    #   "us-east-1", "service", Time.now)
    # signer = Signer::V4.new(request, scope)
    # signer.sign
    # ```
    class V4
      def initialize(request : HTTP::Request, scope : Scope)
        @request = request
        @scope = scope
      end

      # Convert the HTTP::Request into a  request to figure out its
      # signature. Once the signature is calcualated add it to the original
      # HTTP::Request in the Authorization header, thus signing it.
      def sign(add_content_sha : Bool = true)
        # Convert the request into a cr
        body = @request.body
        body = body.responds_to?(:gets_to_end) ? body.gets_to_end : ""
        cr = Request.new(@request.method, URI.parse(@request.path), body)

        @request.query_params.to_h.each do |k, v|
          cr.query.add(k, v)
        end

        # Replace "Date" with X-Amz-Date.
        # Only if X-Amz-Date is not already set. AWS prefers
        # X-Amz-Date
        if date = @request.headers.delete("Date")
          @request.headers["X-Amz-Date"] ||= date
        else
          # Default it to the given scope time, if not set
          @request.headers["X-Amz-Date"] ||= @scope.date.iso8601
        end

        @request.headers.each do |k, v|
          cr.headers.add(Header.new(k, v))
        end

        body_digest = SHA256.digest(body)
        if add_content_sha
          cr.headers.add("X-Amz-Content-Sha256", body_digest)
        end

        # Set the headers on the HTTP::Request
        @request.headers["Authorization"] = Authorization.new(cr, @scope).to_s
        @request.headers["X-Amz-Content-Sha256"] = body_digest if add_content_sha
      end
    end
  end
end
