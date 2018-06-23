require "../../spec_helper"

module Awscr
  module Signer
    module Signers
      describe V2 do
        describe "presign" do
          it "can presign" do
            time = Time.utc(2007, 3, 20, 3, 40, 20)

            Timecop.freeze(time) do
              request = HTTP::Request.new("GET", "/johnsmith/photos/puppy.jpg?Expires=1175139620", HTTP::Headers.new)

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.presign(request)

              request.query_params["AWSAccessKeyId"]?.should eq("AKIAIOSFODNN7EXAMPLE")
              request.query_params["Signature"]?.should eq("NpgCjnDzrM+WFzoENXmpNDUsSn8=")
              request.query_params["Expires"]?.should eq("1175139620")
            end
          end
        end

        describe "#sign" do
          it "can sign get requests" do
            time = Time.utc(2007, 3, 27, 19, 36, 42)

            Timecop.freeze(time) do
              request = HTTP::Request.new("GET", "/johnsmith/photos/puppy.jpg", HTTP::Headers.new)

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.sign(request)

              request.headers["Authorization"].should eq("AWS AKIAIOSFODNN7EXAMPLE:bWq2s1WEIj+Ydj0vQ697zp+IXMU=")
            end
          end

          it "can sign put requests with no body" do
            time = Time.utc(2007, 3, 27, 21, 15, 45)

            Timecop.freeze(time) do
              request = HTTP::Request.new("PUT", "/johnsmith/photos/puppy.jpg", HTTP::Headers{"Content-Type" => "image/jpeg"})

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.sign(request)

              request.headers["Authorization"].should eq("AWS AKIAIOSFODNN7EXAMPLE:MyyxeRY7whkBe+bq8fHCL/2kKUg=")
            end
          end

          it "can sign get with query params" do
            time = Time.utc(2007, 3, 27, 19, 42, 41)

            Timecop.freeze(time) do
              request = HTTP::Request.new("GET", "/johnsmith/?prefix=photos&max-keys=50&marker=puppy", HTTP::Headers.new)

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.sign(request)

              request.headers["Authorization"].should eq("AWS AKIAIOSFODNN7EXAMPLE:htDYFYduRNen8P9ZfE/s9SuKy0U=")
            end
          end

          it "can sign with sub resources" do
            time = Time.utc(2007, 3, 27, 19, 44, 46)

            Timecop.freeze(time) do
              request = HTTP::Request.new("GET", "/johnsmith/?acl", HTTP::Headers.new)

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.sign(request)

              request.headers["Authorization"].should eq("AWS AKIAIOSFODNN7EXAMPLE:c2WLPFtWHVgbEmeEG93a4cG37dM=")
            end
          end

          it "can sign deletes" do
            time = Time.utc(2007, 3, 27, 21, 20, 26)

            Timecop.freeze(time) do
              request = HTTP::Request.new("DELETE", "/johnsmith/photos/puppy.jpg", HTTP::Headers.new)

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.sign(request)

              request.headers["Authorization"].should eq("AWS AKIAIOSFODNN7EXAMPLE:lx3byBScXR6KzyMaifNkardMwNk=")
            end
          end

          it "signs cname style requests" do
            time = Time.utc(2007, 3, 27, 21, 6, 8)

            Timecop.freeze(time) do
              headers = HTTP::Headers.new
              headers.add("Host", "static.johnsmith.net")
              headers.add("x-amz-acl", "public-read")
              headers.add("content-type", "application/x-download")
              headers.add("Content-MD5", "4gJE4saaMU4BqNR0kLY+lw==")
              headers.add("X-Amz-Meta-ReviewedBy", "joe@johnsmith.net")
              headers.add("X-Amz-Meta-ReviewedBy", "jane@johnsmith.net")
              headers.add("X-Amz-Meta-FileChecksum", "0x02661779")
              headers.add("X-Amz-Meta-ChecksumAlgorithm", "crc32")
              headers.add("Content-Disposition", "attachment; filename=database.dat")
              headers.add("Content-Encoding", "gzip")
              headers.add("Content-Length", "5913339")

              request = HTTP::Request.new("PUT", "/db-backup.dat.gz", headers)

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.sign(request)

              request.headers["Authorization"].should eq("AWS AKIAIOSFODNN7EXAMPLE:ilyl83RwaSoYIEdixDQcA4OnAnc=")
            end
          end

          it "signs plain get" do
            time = Time.utc(2007, 3, 28, 1, 29, 59)

            Timecop.freeze(time) do
              request = HTTP::Request.new("GET", "/", HTTP::Headers.new)

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.sign(request)

              request.headers["Authorization"].should eq("AWS AKIAIOSFODNN7EXAMPLE:qGdzdERIC03wnaRNKh6OqZehG9s=")
            end
          end

          it "signs unicode" do
            time = Time.utc(2007, 3, 28, 1, 49, 49)

            Timecop.freeze(time) do
              request = HTTP::Request.new("GET", "/dictionary/fran%C3%A7ais/pr%c3%a9f%c3%a8re", HTTP::Headers.new)

              signer = V2.new("s3", "us-east-1",
                "AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              signer.sign(request)

              request.headers["Authorization"].should eq("AWS AKIAIOSFODNN7EXAMPLE:DNEZGsoieTZ92F3bUfSPQcbGmlM=")
            end
          end
        end
      end
    end
  end
end
