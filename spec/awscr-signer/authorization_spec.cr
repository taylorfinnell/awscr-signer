require "../../spec_helper"

module Awscr
  module Signer
    describe Authorization do
      describe "as a string" do
        it "can contains credential" do
          time = Time.epoch(1440938160)
          scope = Scope.new("key", "secret", "region", "service", time)

          authorization = Authorization.new(
            Request.new("GET", URI.parse("/"), ""),
            scope
          )

          authorization.to_s.should eq "AWS4-HMAC-SHA256 Credential=key/20150830/region/service/aws4_request, SignedHeaders=, Signature=83d6d9f4b052261f0cfca9a0178630bcb2c7f4191709207bc2c0f9a953af3c19"
        end
      end
    end
  end
end
