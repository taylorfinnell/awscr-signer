require "../../spec_helper"

module Awscr
  module Signer
    describe Credentials do
      it "can be a string" do
        credentials = Credentials.new("key", "secret")

        credentials.to_s.should eq "key:secret"
      end

      it "has a key" do
        credentials = Credentials.new("key", "secret")

        credentials.key.should eq "key"
      end

      it "has a secret" do
        credentials = Credentials.new("key", "secret")

        credentials.secret.should eq "secret"
      end

      it "can be compared to another credentials object" do
        credentials = Credentials.new("key", "secret")

        (credentials == Credentials.new("key", "secret")).should be_true
        (credentials == Credentials.new("key1", "secret")).should be_false
        (credentials == Credentials.new("key", "secret1")).should be_false
      end
    end
  end
end
