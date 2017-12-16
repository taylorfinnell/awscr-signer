require "../../spec_helper"

module Awscr
  module Signer::V4
    describe HeaderCollection do
      it "merges dupe headers into a single header with csv without caring about case" do
        headers = HeaderCollection.new
        headers.add(Header.new("header", "1"))
        headers.add(Header.new("HEADER", "2"))

        headers.to_s.should eq "header:1,2\n"
      end

      HeaderCollection::BLACKLIST_HEADERS.each do |hdr|
        it "does not add black listed header #{hdr}" do
          headers = HeaderCollection.new
          headers.add(Header.new(hdr, "xyz"))

          headers.to_a.size.should eq 0
        end
      end

      it "maintains correct order of header values" do
        headers = HeaderCollection.new
        headers.add(Header.new("header", "4"))
        headers.add(Header.new("header", "1"))
        headers.add(Header.new("header", "3"))
        headers.add(Header.new("header", "2"))

        headers.to_a.should eq [Header.new("header", "")]
      end

      it "can set a header with []=" do
        headers = HeaderCollection.new
        headers["x"] = "y"

        headers.to_s.should eq "x:y\n"
      end

      it "can get a header with []" do
        headers = HeaderCollection.new
        headers.add("x", "y")

        headers["x"]?.should eq Header.new("x", "y")

        headers.add("Y", "1")
        (headers["Y"]? != nil).should be_true
      end

      it "returns nil if no header found with []" do
        headers = HeaderCollection.new

        headers["x"]?.should eq nil
      end

      it "merges dupe headers into a single header with csv handles multiline" do
        headers = HeaderCollection.new
        headers.add(Header.new("header", "1"))
        headers.add(Header.new("HEADER", "2"))
        headers.add(Header.new("header", "3\n   4\n 5"))

        headers.to_s.should eq "header:1,2,3,4,5\n"
      end
    end
  end
end
