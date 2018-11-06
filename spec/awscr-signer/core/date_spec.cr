require "../../spec_helper"

module Awscr
  module Signer
    describe Date do
      it "has a timestamp" do
        time = Time.unix(1440938160)
        date = Date.new(time)

        date.timestamp.should eq time
      end

      it "can be represented as YMD" do
        time = Time.unix(1440938160)
        date = Date.new(time)

        date.ymd.should eq "20150830"
      end

      it "can be represented as ISO8601 basic" do
        time = Time.unix(1440938160)
        date = Date.new(time)

        date.iso8601.should eq "20150830T123600Z"
      end

      it "can be RFC1123Z" do
        time = Time.unix(1440938160)
        date = Date.new(time)

        date.rfc1123z.should eq "Sun, 30 Aug 2015 12:36:00 +0000"
      end

      it "can be a string" do
        time = Time.unix(1440938160)
        date = Date.new(time)

        date.to_s.should eq "2015-08-30 12:36:00 UTC"
      end

      it "can be a formatted string" do
        time = Time.unix(1440938160)
        date = Date.new(time)

        date.to_s("%Y").should eq "2015"
      end

      it "can be compared to Time" do
        time = Time.unix(1440938160)
        date = Date.new(time)

        date.should eq(time)
      end

      it "can be compared to a Date object" do
        time = Time.unix(1440938160)
        date = Date.new(time)

        date.should eq(Date.new(time))
      end
    end
  end
end
