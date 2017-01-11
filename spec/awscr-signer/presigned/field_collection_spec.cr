require "../../spec_helper"

module Awscr
  module Signer
    module Presigned
      class TestField < PostField
        def serialize
        end
      end

      describe FieldCollection do
        it "is enumerable" do
          fields = FieldCollection.new
          fields.should be_a(Enumerable(PostField))
        end

        it "can have fields added to it" do
          field = TestField.new("k", "v")

          fields = FieldCollection.new
          fields.push(field)

          fields.to_a.should eq([field])
        end

        it "is empty by default" do
          fields = FieldCollection.new

          fields.to_a.should eq([] of PostField)
        end

        it "does not add dupes" do
          field = TestField.new("k", "v")

          fields = FieldCollection.new
          5.times { fields.push(field) }

          fields.to_a.should eq([field])
        end
      end
    end
  end
end
