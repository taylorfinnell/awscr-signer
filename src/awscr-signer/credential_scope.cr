module Awscr
  module Signer
    class CredentialScope
      def initialize(@credentials : Credentials, @scope : Scope)
      end

      def to_s(io : IO)
        io << "#{@credentials.key}/#{@scope.to_s}"
      end
    end
  end
end
