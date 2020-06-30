require "../../spec_helper"

module Awscr
  module Signer
    module Signers
      describe V4 do
        describe "#sign" do
          time = Time.unix(1420070400)

          it "adds content-sha256 header by default" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/", HTTP::Headers.new, "BODY")

              signer = V4.new("s3", "us-east-1",
                "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
              signer.sign(request)

              digest = OpenSSL::Digest.new("SHA256")
              digest.update("BODY")
              request.headers["X-Amz-Content-Sha256"].should eq(digest.final.hexstring)
              request.headers["Authorization"].should eq("AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150101/us-east-1/s3/aws4_request, SignedHeaders=x-amz-content-sha256;x-amz-date, Signature=791f608d3f2173e73123252f6d3eae407fedbe55d8d62d06fc45bd5ea7584fc0")
            end
          end

          it "replaces date header with x-amz-date" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/")
              request.headers.add("Date", Signer::Date.new(time).iso8601)

              signer = V4.new("s3", "us-east-1",
                "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
              signer.sign(request)

              request.headers.has_key?("Date").should eq(false)
              request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
              request.headers["Authorization"].should eq("AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150101/us-east-1/s3/aws4_request, SignedHeaders=x-amz-content-sha256;x-amz-date, Signature=a0928db39f84c9d7993e5068d68d9ade9440626c9293f81cd73ae86353ccf460")
            end
          end

          it "does not overwrite x-amz-date with date if x-amz-date is set" do
            with_time_freeze(time) do
              time2 = Time.local(2015, 2, 1)

              request = HTTP::Request.new("GET", "/")
              request.headers.add("X-Amz-Date", Signer::Date.new(time2).iso8601)
              request.headers.add("Date", Signer::Date.new(time).iso8601)

              signer = V4.new("s3", "us-east-1",
                "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
              signer.sign(request)

              request.headers.has_key?("Date").should eq(false)
              request.headers["X-Amz-Date"].should eq(Signer::Date.new(time2).iso8601)
              request.headers["Authorization"].should eq("AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150101/us-east-1/s3/aws4_request, SignedHeaders=x-amz-content-sha256;x-amz-date, Signature=bb6067e07d40d9dea1352f442bdd093afaceefe1a80b68990fae4f63474365ea")
            end
          end

          it "sets x-amz-date if not set and no date given" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/")

              signer = V4.new("s3", "us-east-1",
                "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
              signer.sign(request)

              request.headers.has_key?("Date").should eq(false)
              request.headers["X-Amz-Date"].should eq(Signer::Date.new(time).iso8601)
              request.headers["Authorization"].should eq("AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150101/us-east-1/s3/aws4_request, SignedHeaders=x-amz-content-sha256;x-amz-date, Signature=a0928db39f84c9d7993e5068d68d9ade9440626c9293f81cd73ae86353ccf460")
            end
          end

          it "does not overwrite x-amx-date if no date is given and it is set" do
            with_time_freeze(time) do
              time2 = Time.local(2015, 2, 1)
              request = HTTP::Request.new("GET", "/")
              request.headers.add("X-Amz-Date", Signer::Date.new(time2).iso8601)

              signer = V4.new("s3", "us-east-1",
                "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
              signer.sign(request)

              request.headers.has_key?("Date").should eq(false)
              request.headers["X-Amz-Date"].should eq(Signer::Date.new(time2).iso8601)
              request.headers["Authorization"].should eq("AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150101/us-east-1/s3/aws4_request, SignedHeaders=x-amz-content-sha256;x-amz-date, Signature=bb6067e07d40d9dea1352f442bdd093afaceefe1a80b68990fae4f63474365ea")
            end
          end
        end
      end
    end
  end
end
