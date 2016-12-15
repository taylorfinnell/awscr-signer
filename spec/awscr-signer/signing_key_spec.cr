require "../../spec_helper"

module Awscr
  module Signer
    describe SigningKey do
      it "is a canonical signing key" do
        time = Time.epoch(1440938160)
        key = "AKIDEXAMPLE"
        secret = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
        region = "us-east-1"
        service = "service"
        scope = Scope.new(key, secret, region, service, time)

        bytes = Bytes[147, 129, 39, 181, 51, 104, 16, 221, 182, 165, 214, 175, 68, 95, 202, 201, 227, 113, 249, 237, 65, 142, 211, 134, 176, 34, 174, 216, 41, 1, 190, 117]

        key = SigningKey.new(scope)
        key.to_s.should eq(bytes)
      end
    end
  end
end
