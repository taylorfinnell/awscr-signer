require "../../spec_helper"

module Awscr
  module Signer
    describe Uri do
      it "supports relative uri" do
        pending "crystal uri to normalize uri" {
          curi = Uri.new(
            URI.parse("/test/../?x=1")
          )

          curi.to_s.should eq "/"
        }
      end

      it "handles utf8 reasonably" do
        curi = Uri.new(
          URI.parse("/ሴ")
        )

        curi.to_s.should eq "/%E1%88%B4"
      end

      it "encodes the uri" do
        curi = Uri.new(
          URI.parse("/test?x=1")
        )

        curi.to_s.should eq "/test"
      end
    end
  end
end
