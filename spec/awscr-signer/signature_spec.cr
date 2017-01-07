require "../../spec_helper"

module Awscr
  module Signer
    class POSTStringToSign < StringToSign
      def to_s
        raw
      end
    end

    describe Signature do
      it "can support from a string" do
        time = Time.epoch(1375747200)
        key = "AKIAIOSFODNN7EXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "s3"

        str = "test"

        scope = Scope.new(region, service, time)
        sig = Signature.new(scope, str, Credentials.new(key, secret))

        sig.to_s.should eq "baf67ecbecb4b792434efde3c48a815223d743af5bc0a4fb9f23164768cab1c5"
      end

      it "support custom string to sign" do
        time = Time.epoch(1375747200)
        key = "AKIAIOSFODNN7EXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "s3"

        str = "eyAiZXhwaXJhdGlvbiI6ICIyMDEzLTA4LTA3VDEyOjAwOjAwLjAwMFoiLA0KICAiY29uZGl0aW9ucyI6IFsNCiAgICB7ImJ1Y2tldCI6ICJleGFtcGxlYnVja2V0In0sDQogICAgWyJzdGFydHMtd2l0aCIsICIka2V5IiwgInVzZXIvdXNlcjEvIl0sDQogICAgeyJhY2wiOiAicHVibGljLXJlYWQifSwNCiAgICB7InN1Y2Nlc3NfYWN0aW9uX3JlZGlyZWN0IjogImh0dHA6Ly9leGFtcGxlYnVja2V0LnMzLmFtYXpvbmF3cy5jb20vc3VjY2Vzc2Z1bF91cGxvYWQuaHRtbCJ9LA0KICAgIFsic3RhcnRzLXdpdGgiLCAiJENvbnRlbnQtVHlwZSIsICJpbWFnZS8iXSwNCiAgICB7IngtYW16LW1ldGEtdXVpZCI6ICIxNDM2NTEyMzY1MTI3NCJ9LA0KICAgIFsic3RhcnRzLXdpdGgiLCAiJHgtYW16LW1ldGEtdGFnIiwgIiJdLA0KDQogICAgeyJ4LWFtei1jcmVkZW50aWFsIjogIkFLSUFJT1NGT0ROTjdFWEFNUExFLzIwMTMwODA2L3VzLWVhc3QtMS9zMy9hd3M0X3JlcXVlc3QifSwNCiAgICB7IngtYW16LWFsZ29yaXRobSI6ICJBV1M0LUhNQUMtU0hBMjU2In0sDQogICAgeyJ4LWFtei1kYXRlIjogIjIwMTMwODA2VDAwMDAwMFoiIH0NCiAgXQ0KfQ=="

        scope = Scope.new(region, service, time)
        sts = POSTStringToSign.new(scope, str)
        sig = Signature.new(scope, sts, Credentials.new(key, secret))

        sig.to_s.should eq "21496b44de44ccb73d545f1a995c68214c9cb0d41c45a17a5daeec0b1a6db047"
      end

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

        scope = Scope.new(region, service, time)
        sig = Signature.new(scope, canonical_request, Credentials.new(key, secret))

        sig.to_s.should eq("08c7e5a9acfcfeb3ab6b2185e75ce8b1deb5e634ec47601a50643f830c755c01")
      end
    end
  end
end
