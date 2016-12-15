require "../../spec_helper"

module Awscr
  module Signer
    describe HMAC do
      it "can compute digests" do
        bytes = Bytes[136, 205, 33, 8, 181, 52, 125, 151, 60, 243, 156, 223, 144, 83, 215, 221, 66, 112, 72, 118, 216, 201, 169, 189, 142, 45, 22, 130, 89, 211, 221, 247]
        HMAC.digest("test", "test").should eq bytes
      end

      it "can compuete a hex digest" do
        HMAC.hexdigest("test", "test").should eq "88cd2108b5347d973cf39cdf9053d7dd42704876d8c9a9bd8e2d168259d3ddf7"
      end
    end
  end
end
