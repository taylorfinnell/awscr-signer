module Awscr
  module Signer
    module Signers
      class PostSignature
        def initialize(policy : Policy, creds : Credentials, scope : Scope)
          @sig = Signature.new(
            scope,
            PostStringToSign.new(scope, policy.to_s),
            creds
          )
        end

        def to_s
          @sig.to_s
        end
      end
    end
  end
end
