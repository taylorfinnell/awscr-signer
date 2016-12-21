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

      it "can handle spaces" do
        curi = Uri.new("/test ing")

        curi.to_s.should eq "/test%20ing"
      end

      it "can handle multiple slashes" do
        curi = Uri.new("/test ing/stuff")

        curi.to_s.should eq "/test%20ing/stuff"
      end

      it "can handle a path that has a query string" do
        curi = Uri.new("?list-type=2")

        curi.to_s.should eq "/"
      end

      it "can handle a path that has a query string and a slash prefixing it" do
        curi = Uri.new("/?list-type=2")

        curi.to_s.should eq "/"
      end
    end
  end
end
