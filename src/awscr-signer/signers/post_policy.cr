module Awscr
  module Signer
    module Signers
      class PostPolicy
        def initialize(policy : Presigned::Policy, creds : Credentials, scope : Scope)
          @sig = Signature.new(
            scope,
            Presigned::PostStringToSign.new(scope, policy.to_s),
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
