require "../../spec_helper"

module Awscr
  module Signer
    describe Request do
      describe "to_s" do
        it "returns a valid  string" do
          body = ""
          request = Awscr::Signer::Request.new("GET", URI.parse("/"), body)

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
