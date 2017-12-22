require "../../spec_helper"

module Awscr
  module Signer::V4
    describe QueryString do
      it "is enumerable" do
        qs = QueryString.new
        qs.add("a", "b")

        qs.to_a.should eq([{"a", "b"}])
      end

      it "encodes unreserved chars" do
        qs = QueryString.new
        qs.add("@#$%^&+", "/,?><`\";:\\|][{}")

        qs.to_s.should eq "%40%23%24%25%5E%26%2B=%2F%2C%3F%3E%3C%60%22%3B%3A%5C%7C%5D%5B%7B%7D"
      end

      it "returns the query string as a string" do
        qs = QueryString.new
        qs.add("Action", "ListUsers")
        qs.add("Version", "2010-05-08")

        qs.to_s.should eq "Action=ListUsers&Version=2010-05-08"
      end

      it "sorts by the query string key" do
        qs = QueryString.new
        qs.add("a", "b")
        qs.add("F", "c")

        qs.to_s.should eq "F=c&a=b"
      end

      it "handles utf" do
        qs = QueryString.new
        qs.add("ሴ", "bar")

        qs.to_s.should eq "%E1%88%B4=bar"
      end

      it "can handle values with spaces" do
        qs = QueryString.new
        qs.add("p aram1", "val ue1")

        qs.to_s.should eq "p%20aram1=val%20ue1"
      end

      it "enforces the trailing = character on valueless keys" do
        qs = QueryString.new
        qs.add("other", "")
        qs.add("test", "")
        qs.add("x-amz-header", "foo")

        qs.to_s.should eq "other=&test=&x-amz-header=foo"
      end
    end
  end
end
