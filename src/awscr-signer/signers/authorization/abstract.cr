module Awscr
  module Signer
    module Signers
      module AuthorizationStrategy
        abstract def sign(request : HTTP::Request)
      end
    end
  end
end
