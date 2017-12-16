module Awscr
  module Signer
    module Signers
      module Interface
        abstract def sign(request : HTTP::Request)
        abstract def sign(string : String)
        abstract def presign(request)
      end
    end
  end
end
