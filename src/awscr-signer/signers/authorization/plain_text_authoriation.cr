module Awscr
  module Signer
    module Signers
      class PlainTextStrategy
        include AuthorizationStrategy

        def initialize(@scope : Scope, @credentials : Credentials)
        end

        def sign(string)
          string_to_sign = StringToSign.new(@scope, string, raw: true)

          Signature.new(@scope, string_to_sign, @credentials)
        end
      end
    end
  end
end
