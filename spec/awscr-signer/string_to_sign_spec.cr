require "../../spec_helper"

module Awscr
  module Signer
    class FakeScope < Scope
      def to_s
        "FAKE_SCOPE"
      end
    end

    describe StringToSign do
      describe "raw" do
        it "returns underlying string" do
          time = Time.epoch(1440938160)
          key = "AKIDEXAMPLE"
          secret = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
          region = "us-east-1"
          service = "service"
          data = "test"

          scope = FakeScope.new(region, service, time)

          sts = StringToSign.new(scope, data)
          sts.raw.should eq(data)
        end
      end

      it "returns raw string if raw is true" do
        time = Time.epoch(1440938160)
        key = "AKIDEXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "service"
        data = "test"

        scope = FakeScope.new(region, service, time)

        sts = StringToSign.new(scope, data, raw: true)
        sts.to_s.should eq(data)
      end

      it "contains the algorithm" do
        time = Time.epoch(1440938160)
        key = "AKIDEXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "service"
        data = "test"

        scope = FakeScope.new(region, service, time)

        sts = StringToSign.new(scope, data)
        sts.to_s.split("\n")[0].should eq Signer::ALGORITHM
      end

      it "contains the correctly formatted date" do
        time = Time.epoch(1440938160)
        key = "AKIDEXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "service"
        data = "test"

        scope = FakeScope.new(region, service, time)

        sts = StringToSign.new(scope, data)
        sts.to_s.split("\n")[1].should eq Date.new(time).iso8601
      end

      it "contains the scope string" do
        time = Time.epoch(1440938160)
        key = "AKIDEXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "service"
        data = "test"

        scope = FakeScope.new(region, service, time)

        sts = StringToSign.new(scope, data)
        sts.to_s.split("\n")[2].should eq "FAKE_SCOPE"
      end

      it "contains the digest of the string" do
        time = Time.epoch(1440938160)
        key = "AKIDEXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "service"
        data = "test"

        scope = FakeScope.new(region, service, time)

        sts = StringToSign.new(scope, data)
        sts.to_s.split("\n")[3].should eq SHA256.digest(data)
      end
    end
  end
end
