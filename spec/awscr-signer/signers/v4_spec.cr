require "../../spec_helper"

module Awscr
  module Signer
    module Signers
      describe V4 do
        Spec.before_each do
          Timecop.freeze(Time.new(2015, 1, 1))
        end

        Spec.after_each do
          Timecop.reset
        end

        it "adds content-sha256 header by default" do
          request = HTTP::Request.new("GET", "/", HTTP::Headers.new, "BODY")

          signer = V4.new("s3", "us-east-1",
            "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          signer.sign(request)

          request.headers["X-Amz-Content-Sha256"].should eq(SHA256.digest("BODY"))
        end

        it "replaces date header with x-amz-date" do
          time = Time.new(2015, 1, 1)

          request = HTTP::Request.new("GET", "/")
          request.headers.add("Date", Signer::Date.new(time).iso8601)

          signer = V4.new("s3", "us-east-1",
            "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          signer.sign(request, false)

          request.headers.has_key?("Date").should eq(false)
          request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
        end

        it "does not overwrite x-amz-date with date if x-amz-date is set" do
          time = Time.new(2015, 1, 1)
          time2 = Time.new(2015, 2, 1)

          request = HTTP::Request.new("GET", "/")
          request.headers.add("X-Amz-Date", Signer::Date.new(time2).iso8601)
          request.headers.add("Date", Signer::Date.new(time).iso8601)

          signer = V4.new("s3", "us-east-1",
            "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          signer.sign(request, false)

          request.headers.has_key?("Date").should eq(false)
          request.headers["X-Amz-Date"].should eq(Signer::Date.new(time2).iso8601)
        end

        it "sets x-amz-date if not set and no date given" do
          time = Time.new(2015, 1, 1)

          request = HTTP::Request.new("GET", "/")

          signer = V4.new("s3", "us-east-1",
            "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          signer.sign(request, false)

          request.headers.has_key?("Date").should eq(false)
          request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
        end

        it "does not overwrite x-amx-date if no date is given and it is set" do
          time = Time.new(2015, 2, 1)

          request = HTTP::Request.new("GET", "/")
          request.headers.add("X-Amz-Date", Signer::Date.new(time).iso8601)

          signer = V4.new("s3", "us-east-1",
            "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          signer.sign(request, false)

          request.headers.has_key?("Date").should eq(false)
          request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
        end
      end
    end
  end
end
