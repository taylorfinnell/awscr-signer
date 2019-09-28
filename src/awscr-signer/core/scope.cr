module Awscr
  module Signer
    # Represents the `Scope` of a `Request`
    #
    # ```
    # scope = Scope.new("s3", "us-east-1", Time.now)
    # ```
    class Scope
      # The service of the `Scope`
      getter service : String

      # The region of the `Scope`
      getter region : String

      # The date used in the scope
      getter date : Date

      def initialize(region : String, service : String, timestamp : Time = Time.utc)
        @date = Awscr::Signer::Date.new(timestamp)
        @region = region
        @service = service
      end

      # Return the `Scope` as a string
      def to_s(io : IO)
        io << [@date.ymd, region, service, "aws4_request"].join("/")
      end
    end
  end
end
