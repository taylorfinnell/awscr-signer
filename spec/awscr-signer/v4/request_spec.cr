require "../../spec_helper"

module Awscr
  module Signer::V4
    describe Request do
      it "does not modify http request body" do
        body = IO::Memory.new("body")
        request = Request.new("GET", URI.parse("/"), body)
        body.gets_to_end.should eq("body")
      end

      it "alerts of ignored query params" do
        expect_raises do
          Request.new("GET", URI.parse("http://google.com?test=1"), "")
        end
      end

      describe "digest" do
        it "returns unsigned payload if body is unsigned payload" do
          request = Request.new("GET", URI.parse("/"), "UNSIGNED-PAYLOAD")

          request.digest.should eq("UNSIGNED-PAYLOAD")
        end

        it "returns digest of body" do
          body = IO::Memory.new("body")
          request = Request.new("GET", URI.parse("/"), body)

          request.digest.should eq("230d8358dc8e8890b4c58deeb62912ee2f20357ae92a5cc861b98e68fe31acb5")
        end
      end

      describe "host" do
        it "returns the uri host" do
          request = Request.new("GET", URI.parse("/"), "")
          request.host.should eq(nil)
        end
      end

      describe "full_path" do
        it "returns the full url incl query string" do
          request = Request.new("GET", URI.parse("http://google.com"), "")
          request.query.add("blah", "1")

          request.full_path.should eq("http://google.com?blah=1")
        end
      end

      describe "to_s" do
        it "returns a valid  string" do
          body = ""
          request = Request.new("GET", URI.parse("/"), body)

          request.headers.add("Content-Type", "application/x-www-form-urlencoded; charset=utf-8")
          request.headers.add("Host", "iam.amazonaws.com")
          request.headers.add("x-amz-date", "20150830T123600Z")

          request.query.add("Action", "ListUsers")
          request.query.add("Version", "2010-05-08")

          canaonical_request = "GET
/
Action=ListUsers&Version=2010-05-08
content-type:application/x-www-form-urlencoded; charset=utf-8
host:iam.amazonaws.com
x-amz-date:20150830T123600Z

content-type;host;x-amz-date
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

          request.to_s.should eq canaonical_request
        end
      end
    end
  end
end
