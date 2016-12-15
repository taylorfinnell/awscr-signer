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

      def <=>(time : Time)
        @timestamp <=> time
      end

      def <=>(date : Date)
        @timestamp <=> date.timestamp
      end
    end
  end
end
