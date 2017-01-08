module Awscr
  module Signer
    module Presigned
      # Represents the URL and fields required to send a HTTP form POST to S3
      # for object uploading.
      class Post
        def initialize(region : String, credentials : Credentials, time : Time = Time.utc_now)
          @scope = Scope.new(region, "s3", time)
          @policy = Policy.new
          @credentials = credentials
        end

        def build(&block)
          yield @policy
        end

        def valid?
          !!(bucket && @policy.valid?)
        end

        def url
          raise Exception.new("Invalid URL, no bucket field") unless bucket
          "http://#{bucket}.s3.amazonaws.com"
        end

        # Returns the fields, without signature fields
        def fields
          policy = policy_with_signature_fields
          signature = signature(policy).to_s
          policy.eq("policy", policy.to_s)
          policy.eq("x-amz-signature", signature)
          policy.fields
        end

        # Represent this `Presigned::Post` as raw HTML.
        def to_html
          HtmlPrinter.new(self)
        end

        # Returns a new `Policy` object with the x-amz signaure fields
        private def policy_with_signature_fields
          @policy.dup.tap do |policy|
            policy.eq("x-amz-credential", credential_scope)
            policy.eq("x-amz-algorithm", Signer::ALGORITHM)
            policy.eq("x-amz-date", @scope.date.iso8601)
          end
        end

        # :nodoc:
        private def credential_scope
          CredentialScope.new(@credentials, @scope).to_s
        end

        # :nodoc:
        private def signature(policy)
          Signers::PostSignature.new(policy, @credentials, @scope)
        end

        # :nodoc:
        private def bucket
          if bucket = fields.find { |field| field.key == "bucket" }
            bucket.value.join
          end
        end
      end
    end
  end
end
