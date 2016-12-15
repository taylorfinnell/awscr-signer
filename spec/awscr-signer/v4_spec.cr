require "../../spec_helper"

module Awscr
  module Signer
    describe V4 do
      it "replaces date header with x-amz-date" do
        time = Time.new(2015, 1, 1)

        scope = Awscr::Signer::Scope.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY",
          "us-east-1", "service", time)

        request = HTTP::Request.new("GET", "/")
        request.headers.add("Date", scope.date.iso8601)

        signer = V4.new(request, scope)
        signer.sign

        request.headers.has_key?("Date").should eq(false)
        request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
      end

      it "does not overwrite x-amz-date with date if x-amz-date is set" do
        time = Time.new(2015, 1, 1)
        time2 = Time.new(2015, 2, 1)

        scope = Awscr::Signer::Scope.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY",
          "us-east-1", "service", time)

        request = HTTP::Request.new("GET", "/")
        request.headers.add("X-Amz-Date", Signer::Date.new(time2).iso8601)
        request.headers.add("Date", scope.date.iso8601)

        signer = V4.new(request, scope)
        signer.sign

        request.headers.has_key?("Date").should eq(false)
        request.headers["X-Amz-Date"].should eq(Signer::Date.new(time2).iso8601)
      end

      it "sets x-amz-date if not set and no date given" do
        time = Time.new(2015, 1, 1)
        scope = Awscr::Signer::Scope.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY",
          "us-east-1", "service", time)

        request = HTTP::Request.new("GET", "/")

        signer = V4.new(request, scope)
        signer.sign

        request.headers.has_key?("Date").should eq(false)
        request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
      end

      it "does not overwrite x-amx-date if no date is given and it is set" do
        time = Time.new(2015, 2, 1)

        scope = Awscr::Signer::Scope.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY",
          "us-east-1", "service", time)

        request = HTTP::Request.new("GET", "/")
        request.headers.add("X-Amz-Date", Signer::Date.new(time).iso8601)

        signer = V4.new(request, scope)
        signer.sign

        request.headers.has_key?("Date").should eq(false)
        request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
      end
    end
  end
end
