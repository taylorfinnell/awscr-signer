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
    end
  end
end
