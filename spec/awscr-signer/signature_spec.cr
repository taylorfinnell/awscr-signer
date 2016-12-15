require "../../spec_helper"

module Awscr
  module Signer
    describe Signature do
      it "can be a string" do
        time = Time.epoch(1440938160)
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

        scope = Scope.new(key, secret, region, service, time)
        sig = Signature.new(scope, canonical_request)

        sig.to_s.should eq("08c7e5a9acfcfeb3ab6b2185e75ce8b1deb5e634ec47601a50643f830c755c01")
      end
    end
  end
end
