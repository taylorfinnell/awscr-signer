require "../../spec_helper"

module Awscr
  module Signer::V2
    describe Signature do
      it "returns reasonable sig" do
        time = Time.local(2007, 3, 27, 19, 36, 42)
        date = Signer::Date.new(time)
        scope = Signer::Scope.new("us-east-1", "s3", time)
        creds = Signer::Credentials.new("AKIAIOSFODNN7EXAMPLE",
          "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

        sts = "GET


Tue, 27 Mar 2007 19:36:42 +0000
/johnsmith/photos/puppy.jpg"

        sig = Signature.new(scope, sts, creds)
        sig.to_s.should eq("bWq2s1WEIj+Ydj0vQ697zp+IXMU=")
      end

      it "gives reasonable signature for http request" do
        request = Request.new("PUT", URI.parse("/static.johnsmith.net/db-backup.dat.gz"), nil)
        request.headers.add("X-Amz-Date", "Tue, 27 Mar 2007 21:06:08 +0000")

        request.headers.add("x-amz-acl", "public-read")
        request.headers.add("content-type", "application/x-download")
        request.headers.add("Content-MD5", "4gJE4saaMU4BqNR0kLY+lw==")
        request.headers.add("X-Amz-Meta-ReviewedBy", "joe@johnsmith.net")
        request.headers.add("X-Amz-Meta-ReviewedBy", "jane@johnsmith.net")
        request.headers.add("X-Amz-Meta-FileChecksum", "0x02661779")
        request.headers.add("X-Amz-Meta-ChecksumAlgorithm", "crc32")
        request.headers.add("Content-Disposition", "attachment; filename=database.dat")
        request.headers.add("Content-Encoding", "gzip")
        request.headers.add("Content-Length", "5913339")

        time = Time.local(2007, 3, 27, 21, 6, 8)
        date = Signer::Date.new(time)
        scope = Signer::Scope.new("us-east-1", "s3", time)
        creds = Signer::Credentials.new("AKIAIOSFODNN7EXAMPLE",
          "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

        sig = Signature.new(scope, request, creds)
        sig.to_s.should eq("ilyl83RwaSoYIEdixDQcA4OnAnc=")
      end
    end
  end
end
