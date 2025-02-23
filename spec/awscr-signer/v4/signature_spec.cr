require "../../spec_helper"

module Awscr
  module Signer::V4
    describe Signature do
      it "can support from a string" do
        time = Time.unix(1375747200)
        key = "AKIAIOSFODNN7EXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "s3"

        str = "test"

        scope = Scope.new(region, service, time)
        sig = Signature.new(scope, str, Credentials.new(key, secret))

        sig.to_s.should eq "baf67ecbecb4b792434efde3c48a815223d743af5bc0a4fb9f23164768cab1c5"
      end

      it "can be a string" do
        time = Time.unix(1440938160)
        key = "AKIDEXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "service"

        canonical_request = "GET
/

host:example.amazonaws.com
my-header1:value4,value1,value3,value2
x-amz-date:20150830T123600Z

host;my-header1;x-amz-date
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

        scope = Scope.new(region, service, time)
        sig = Signature.new(scope, canonical_request, Credentials.new(key, secret))

        sig.to_s.should eq("08c7e5a9acfcfeb3ab6b2185e75ce8b1deb5e634ec47601a50643f830c755c01")
      end
      #
      # https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-query-string-auth.html#query-string-auth-v4-signing-example
      it "example from official docs" do
        time = Time.unix(1369353600) # Request timestamp is Fri, 24 May 2013 00:00:00 GMT.

        key = "AKIAIOSFODNN7EXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "s3"
        canonical_request = <<-REQUEST
        GET
        /test.txt
        X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIOSFODNN7EXAMPLE%2F20130524%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20130524T000000Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host
        host:examplebucket.s3.amazonaws.com

        host
        UNSIGNED-PAYLOAD
        REQUEST

        scope = Scope.new(region, service, time)
        sig = Signature.new(scope, canonical_request, Credentials.new(key, secret))

        sig.to_s.should eq("aeeed9bbccd4d02ee5c0109b86d86835f995330da4c265957d157751f604d404")
      end
    end
  end
end
