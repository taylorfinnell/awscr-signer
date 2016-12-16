require "../../spec_helper"

module Awscr
  module Signer
    describe Scope do
      it "has a service" do
        scope = Scope.new("region", "service", Time.now)

        scope.service.should eq "service"
      end

      it "has a region" do
        scope = Scope.new("region", "service", Time.now)

        scope.region.should eq "region"
      end

      it "has a date" do
        time = Time.now
        scope = Scope.new("region", "service", time)

        scope.date.should eq time
      end

      it "can be represented as a string" do
        time = Time.epoch(1440938160)
        scope = Scope.new("region", "service", time)

        scope.to_s.should eq "20150830/region/service/aws4_request"
      end
    end
  end
end
