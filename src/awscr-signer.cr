require "./awscr-signer/core/*"
require "./awscr-signer/*"

module Awscr
  # Implementation of AWS VERSION 4 signing
  module Signer
    ALGORITHM = "AWS4-HMAC-SHA256"
  end
end
