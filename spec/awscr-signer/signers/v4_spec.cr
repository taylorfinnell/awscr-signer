require "../../spec_helper"

module Awscr
  module Signer
    module Signers
      describe V4 do
        it "adds content-sha256 header by default" do
          time = Time.new(2015, 1, 1)

          creds = Credentials.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          scope = Scope.new("us-east-1", "service", time)

          request = HTTP::Request.new("GET", "/", HTTP::Headers.new, "BODY")

          signer = V4.new(scope, creds)
          signer.sign(request)

          request.headers["X-Amz-Content-Sha256"].should eq(SHA256.digest("BODY"))
        end

        it "replaces date header with x-amz-date" do
          time = Time.new(2015, 1, 1)

          creds = Credentials.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          scope = Scope.new("us-east-1", "service", time)

          request = HTTP::Request.new("GET", "/")
          request.headers.add("Date", scope.date.iso8601)

          signer = V4.new(scope, creds)
          signer.sign(request, false)

          request.headers.has_key?("Date").should eq(false)
          request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
        end

        it "does not overwrite x-amz-date with date if x-amz-date is set" do
          time = Time.new(2015, 1, 1)
          time2 = Time.new(2015, 2, 1)

          creds = Credentials.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          scope = Awscr::Signer::Scope.new("us-east-1", "service", time)

          request = HTTP::Request.new("GET", "/")
          request.headers.add("X-Amz-Date", Signer::Date.new(time2).iso8601)
          request.headers.add("Date", scope.date.iso8601)

          signer = V4.new(scope, creds)
          signer.sign(request, false)

          request.headers.has_key?("Date").should eq(false)
          request.headers["X-Amz-Date"].should eq(Signer::Date.new(time2).iso8601)
        end

        it "sets x-amz-date if not set and no date given" do
          time = Time.new(2015, 1, 1)
          creds = Credentials.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          scope = Awscr::Signer::Scope.new("us-east-1", "service", time)

          request = HTTP::Request.new("GET", "/")

          signer = V4.new(scope, creds)
          signer.sign(request, false)

          request.headers.has_key?("Date").should eq(false)
          request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
        end

        it "does not overwrite x-amx-date if no date is given and it is set" do
          time = Time.new(2015, 2, 1)

          creds = Credentials.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
          scope = Awscr::Signer::Scope.new("us-east-1", "service", time)

          request = HTTP::Request.new("GET", "/")
          request.headers.add("X-Amz-Date", Signer::Date.new(time).iso8601)

          signer = V4.new(scope, creds)
          signer.sign(request, false)

          request.headers.has_key?("Date").should eq(false)
          request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
        end
      end
    end
  end
end
