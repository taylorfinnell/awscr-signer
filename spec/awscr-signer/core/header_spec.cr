require "../../spec_helper"

module Awscr
  module Signer
    describe Header do
      it "can be creted from a key and array of values" do
        header = Header.new("k", ["g", "v"])

        header.key.should eq("k")
        header.value.should eq("g,v")
      end

      it "is instantiated from a kv" do
        header = Header.new("k", "v")

        header.key.should eq("k")
        header.value.should eq("v")
      end

      it "has multiple values if new lines" do
        header = Header.new("k", "v  \ng")

        header.value.should eq("v,g")
      end

      it "strips leading whitespace from the value" do
        header = Header.new("k", "  v")

        header.key.should eq("k")
        header.value.should eq("v")
      end

      it "strips trailing whitespace from the value" do
        header = Header.new("k", "v   ")

        header.key.should eq("k")
        header.value.should eq("v")
      end

      it "strips both leading and trailing from the value" do
        header = Header.new("k", "  v   ")

        header.key.should eq("k")
        header.value.should eq("v")
      end

      it "replaces repeating white space from the value" do
        header = Header.new("k", "  v    v  ")

        header.key.should eq("k")
        header.value.should eq("v v")
      end

      it "downcases the key" do
        header = Header.new("HI", "v")

        header.key.should eq("hi")
      end

      it "can be compared to another header" do
        header = Header.new("k", "v")

        (header == Header.new("k", "v")).should be_true
        (header == Header.new("k", "b")).should be_true # header equality is on key only
        (header == Header.new("f", "c")).should be_false
      end

      it "can compare to a string" do
        header = Header.new("k", "v")

        (header == "k").should be_true
        (header == "K").should be_true
        (header == "a").should be_false
      end

      it "can be represented as a string" do
        header = Header.new("k", "v")
        header.to_s.should eq "k:v"
      end

      it "can be created from a multivalue value" do
        header = Header.new("hi", "v,v")

        header.value.should eq("v,v")
      end

      it "can be created from a multi line multi value value" do
        header = Header.new("hi", "v,v\nv")

        header.value.should eq("v,v,v")
      end

      it "can add values after header creation" do
        header = Header.new("hi", "v")
        header.merge("t")

        header.to_s.should eq("hi:v,t")
      end

      it "can add values after header creation from another header" do
        header = Header.new("hi", "v")
        header.merge(Header.new("hi", "t"))

        header.to_s.should eq("hi:v,t")
      end
    end
  end
end
