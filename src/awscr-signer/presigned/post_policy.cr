require "base64"
require "json"

module Awscr
  module Signer
    class Policy
      @expiration : Time?

      getter expiration
      getter fields

      def initialize
        @fields = FieldCollection.new
      end

      def expiration(time : Time)
        @expiration = time
      end

      def valid?
        # @todo check that the sig keys exist
        !!!@expiration.nil?
      end

      def eq(key : String, value : String | Int32)
        @fields.push(EqualField.new(key, [value]))
        self
      end

      def to_hash
        return {} of String => String unless valid?

        {
          "expiration" => @expiration.not_nil!.to_s("%Y-%m-%dT%H:%M:%S.000Z"),
          "conditions" => @fields.map(&.serialize),
        }
      end

      def to_s(io : IO)
        io << Base64.strict_encode(to_hash.to_json)
      end
    end

    PostPolicy = Policy
  end
end
