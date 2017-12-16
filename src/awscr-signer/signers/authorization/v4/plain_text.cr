module Awscr
  module Signer
    module Signers
      module Authorization::V4
        class PlainText
          def initialize(@scope : Scope, @credentials : Credentials)
          end

          def sign(string : String)
            sig = Signer::V4::Signature.new(@scope, string, @credentials, compute_digest: false)
            sig.to_s
          end
        end
      end
    end
  end
end
