module Awscr
  module Signer
    module Signers
      module Authorization
        class String
          def initialize(@scope : Scope, @credentials : Credentials)
          end

          def sign(string : ::String)
            sig = Signature.new(@scope, string, @credentials, compute_digest: false)
            sig.to_s
          end
        end
      end
    end
  end
end
