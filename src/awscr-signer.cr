require "./awscr-signer/core/*"
require "./awscr-signer/v4/*"
require "./awscr-signer/*"

module Awscr
  # Implementation of AWS request signing
  module Signer
    V4_ALGORITHM = "AWS4-HMAC-SHA256"
  end
end
