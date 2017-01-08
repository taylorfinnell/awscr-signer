require "./awscr-signer/*"
require "secure_random"

module Awscr
  # Implementation of AWS VERSION 4 signing
  module Signer
    ALGORITHM = "AWS4-HMAC-SHA256"
  end
end
