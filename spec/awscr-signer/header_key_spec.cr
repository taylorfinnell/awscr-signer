require "../../spec_helper"

module Awscr
  module Signer
    describe HeaderKey do
      it "is created from a string" do
        HeaderKey.new("key")
      end

      it "downcases they key with to_s" do
        key = HeaderKey.new("KEY")
        key.to_s.should eq "key"
      end
    end
  end
end
