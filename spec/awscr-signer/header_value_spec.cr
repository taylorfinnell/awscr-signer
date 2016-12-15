require "../../spec_helper"

module Awscr
  module Signer
    describe HeaderValue do
      it "can be created from a string" do
        value = HeaderValue.new("1")

        value.to_s.should eq("1")
      end

      it "can be created from an array" do
        value = HeaderValue.new(["1", "2"])

        value.to_s.should eq("1,2")
      end

      it "it leading space" do
        value = HeaderValue.new("   1")

        value.to_s.should eq("1")
      end

      it "trims trailing space" do
        value = HeaderValue.new("1   ")

        value.to_s.should eq("1")
      end

      it "trims repeated space" do
        value = HeaderValue.new("1  1")

        value.to_s.should eq("1 1")
      end

      it "can handle multi lines" do
        value = HeaderValue.new("1\n2")

        value.to_s.should eq("1,2")
      end

      it "can handle csv" do
        value = HeaderValue.new("1,1")

        value.to_s.should eq("1,1")
      end

      it "can handle multiline and csv" do
        value = HeaderValue.new("1,1\n  2")

        value.to_s.should eq("1,1,2")
      end

      describe "merging a value" do
        it "maintains order" do
          value = HeaderValue.new("1")
          value.merge("3")
          value.merge("2")

          value.to_s.should eq("1,3,2")
        end

        it "can be represented as a string" do
          value = HeaderValue.new("1")
          value.merge("2")

          value.to_s.should eq("1,2")
        end
      end
    end
  end
end
