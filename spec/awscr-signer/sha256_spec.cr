require "../../spec_helper"

module Awscr
  module Signer
    describe SHA256 do
      it "returns a downcased sha of the string" do
        sha = SHA256.digest("test")
        sha.should eq "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
      end
    end
  end
end
