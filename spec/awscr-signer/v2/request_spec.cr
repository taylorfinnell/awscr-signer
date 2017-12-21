require "../../spec_helper"

module Awscr
  module Signer::V2
    describe Request do
      describe "#to_s" do
        it "works with get" do
          request = Request.new("GET", URI.parse("/johnsmith/photos/puppy.jpg"), nil)
          request.headers.add("X-Amz-Date", "Tue, 27 Mar 2007 19:36:42 +0000")

          expected = "GET


Tue, 27 Mar 2007 19:36:42 +0000
/johnsmith/photos/puppy.jpg"

          request.to_s.should eq(expected)
        end

        it "works with put and no body" do
          request = Request.new("PUT", URI.parse("/johnsmith/photos/puppy.jpg"), nil)
          request.headers.add("X-Amz-Date", "Tue, 27 Mar 2007 21:15:45 +0000")
          request.headers.add("Content-Type", "image/jpeg")

          expected = "PUT

image/jpeg
Tue, 27 Mar 2007 21:15:45 +0000
/johnsmith/photos/puppy.jpg"

          request.to_s.should eq(expected)
        end

        it "handles query strings" do
          request = Request.new("GET", URI.parse("/johnsmith/?prefix=photos&max-keys=50&marker=puppy"), nil)
          request.headers.add("User-Agent", "Mozilla/5.0")
          request.headers.add("X-Amz-Date", "Tue, 27 Mar 2007 19:42:41 +0000")

          expected = "GET


Tue, 27 Mar 2007 19:42:41 +0000
/johnsmith/"

          request.to_s.should eq(expected)
        end

        it "handles subresources" do
          request = Request.new("GET", URI.parse("/johnsmith/?acl"), nil)
          request.headers.add("X-Amz-Date", "Tue, 27 Mar 2007 19:44:46 +0000")
          request.query_params.add("acl", "")

          expected = "GET


Tue, 27 Mar 2007 19:44:46 +0000
/johnsmith/?acl"

          request.to_s.should eq(expected)
        end

        it "handles cname style requets" do
          request = Request.new("PUT", URI.parse("/db-backup.dat.gz"), nil)
          request.headers.add("X-Amz-Date", "Tue, 27 Mar 2007 21:06:08 +0000")
          request.headers.add("Host", "static.johnsmith.net:8080")

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

          expected = "PUT
4gJE4saaMU4BqNR0kLY+lw==
application/x-download
Tue, 27 Mar 2007 21:06:08 +0000
x-amz-acl:public-read
x-amz-meta-checksumalgorithm:crc32
x-amz-meta-filechecksum:0x02661779
x-amz-meta-reviewedby:joe@johnsmith.net,jane@johnsmith.net
/static.johnsmith.net/db-backup.dat.gz"

          request.to_s.should eq(expected)
        end
      end
    end
  end
end
