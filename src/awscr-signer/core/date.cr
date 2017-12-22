module Awscr
  module Signer
    # A wrapper to provide time formats required by signing
    #
    # ```
    # date = Date.new(Time.now)
    # date.ymd
    # date.iso8601
    # ```
    class Date
      include Comparable(Time)

      DATE_YMD      = "%Y%m%d"
      ISO8601_BASIC = "%Y%m%dT%H%M%SZ"
      RFC1123Z      = "%a, %d %b %Y %H:%M:%S %z"

      getter timestamp

      def initialize(timestamp : Time)
        @timestamp = timestamp
      end

      # Delegate to_s to the underlying time
      def to_s(*args)
        @timestamp.to_s(*args)
      end

      # Return the date in YYMMDD format
      def ymd
        @timestamp.to_s(DATE_YMD)
      end

      # Return the date in ISO8601 basic format
      def iso8601
        @timestamp.to_s(ISO8601_BASIC)
      end

      # Return the date in RFC1123Z format
      def rfc1123z
        @timestamp.to_s(RFC1123Z)
      end

      # Compare the `Date` object to a `Time` object
      def <=>(time : Time)
        @timestamp <=> time
      end

      def_equals @timestamp
    end
  end
end
