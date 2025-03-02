require "log"

require "./awscr-signer/core/*"
require "./awscr-signer/v4/*"
require "./awscr-signer/v2/*"
require "./awscr-signer/signers/*"

module Awscr
  # Implementation of AWS request signing
  module Signer
    ALGORITHM = "AWS4-HMAC-SHA256"
    Log       = ::Log.for("awscr-signer")
  end
end
