require "../../spec_helper"

module Awscr
  module Signer::V4
    describe Uri do
      it "can be created from a string" do
        curi = Uri.new("https://www.google.com/blah")

        curi.to_s.should eq("https://www.google.com/blah")
      end

      describe "to_s" do
        it "full uri as string" do
          curi = Uri.new(
            URI.parse("https://www.google.com/blah")
          )

          curi.to_s.should eq("https://www.google.com/blah")
        end
      end

      describe "host" do
        it "returns host" do
          curi = Uri.new("https://www.google.com/blah")

          curi.host.should eq("www.google.com")
        end

        it "gives nil if no host" do
          curi = Uri.new("/")

          curi.host.should eq(nil)
        end
      end

      describe "path" do
        it "supports empty" do
          curi = Uri.new(
            URI.parse("/")
          )

          curi.path.should eq "/"
        end

        it "supports slash" do
          curi = Uri.new(
            URI.parse("/")
          )

          curi.path.should eq "/"
        end

        it "supports relative uri" do
          curi = Uri.new(
            URI.parse("/test/../?x=1")
          )

          curi.path.should eq "/"
        end

        it "handles utf8 reasonably" do
          curi = Uri.new(
            URI.parse("/ሴ")
          )

          curi.path.should eq "/%E1%88%B4"
        end

        it "encodes the uri" do
          curi = Uri.new(
            URI.parse("/test?x=1")
          )

          curi.path.should eq "/test"
        end

        it "can handle spaces" do
          curi = Uri.new("/test ing")

          curi.path.should eq "/test%20ing"
        end

        it "can handle multiple slashes" do
          curi = Uri.new("/test ing/stuff")

          curi.path.should eq "/test%20ing/stuff"
        end

        it "can handle a path that has a query string" do
          curi = Uri.new("?list-type=2")

          curi.path.should eq "/"
        end

        it "can handle a path that has a query string and a slash prefixing it" do
          curi = Uri.new("/?list-type=2")

          curi.path.should eq "/"
        end
      end
    end
  end
end
