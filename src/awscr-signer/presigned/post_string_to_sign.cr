require "../string_to_sign"

module Awscr
  module Signer
    module Presigned
      class PostStringToSign < Signer::StringToSign
        def to_s
          raw
        end
      end
    end
  end
end
