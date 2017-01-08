require "../../spec_helper"

module Awscr
  module Signer
    module Presigned
      describe PostStringToSign do
        describe "to_s" do
          it "returns unmodified string" do
            scope = Scope.new("test", "s3")
            sts = PostStringToSign.new(scope, "blah")

            sts.to_s.should eq "blah"
          end
        end
      end
    end
  end
end
