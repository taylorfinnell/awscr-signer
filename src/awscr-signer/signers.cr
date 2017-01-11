module Awscr
  module Signer
    module Signers
    end
  end
end

require "./signers/*"

# For backwards compatability
module Awscr
  module Signer
    V4 = Signers::V4
  end
end
