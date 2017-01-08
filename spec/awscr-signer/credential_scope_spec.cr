require "../../spec_helper"

module Awscr
  module Signer
    describe CredentialScope do
      describe "to_s" do
        it "is a valid credential scope string" do
          time = Time.epoch(1)
          creds = Credentials.new("test", "test")
          scope = Scope.new("region", "service", time)
          cs = CredentialScope.new(creds, scope)

          cs.to_s.should eq("test/19700101/region/service/aws4_request")
        end
      end
    end
  end
end
