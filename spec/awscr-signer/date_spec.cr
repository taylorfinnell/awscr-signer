require "../../spec_helper"

module Awscr
  module Signer
    describe Date do
      it "has a timestamp" do
        time = Time.epoch(1440938160)
        date = Date.new(time)

        date.timestamp.should eq time
      end

      it "can be represented as YMD" do
        time = Time.epoch(1440938160)
        date = Date.new(time)

        date.ymd.should eq "20150830"
      end

      it "can be represented as ISO8601 basic" do
        time = Time.epoch(1440938160)
        date = Date.new(time)

        date.iso8601.should eq "20150830T123600Z"
      end

      it "can be a string" do
        time = Time.epoch(1440938160)
        date = Date.new(time)

        date.to_s.should eq "2015-08-30 12:36:00 UTC"
      end

      it "can be a formatted string" do
        time = Time.epoch(1440938160)
        date = Date.new(time)

        date.to_s("%Y").should eq "2015"
      end
    end
  end
end
