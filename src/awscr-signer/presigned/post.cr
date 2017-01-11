require "./post_policy"

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

        # Build a post object by adding fields
        def build(&block)
          yield @policy

          @policy.condition("x-amz-credential", credential_scope)
          @policy.condition("x-amz-algorithm", Signer::ALGORITHM)
          @policy.condition("x-amz-date", @scope.date.iso8601)

          # Calculate sig of full policy with sig fields
          signature = signature(@policy).to_s

          # Add the final fields
          @policy.condition("policy", @policy.to_s)
          @policy.condition("x-amz-signature", signature)
          self
        end

        # Returns if the post is valid, false otherwise
        def valid?
          !!(bucket && @policy.valid?)
        end

        # Return the url to post to
        def url
          raise Exception.new("Invalid URL, no bucket field") unless bucket
          "http://#{bucket}.s3.amazonaws.com"
        end

        # Returns the fields, without signature fields
        def fields
          @policy.fields
        end

        # Represent this `Presigned::Post` as raw HTML.
        def to_html
          HtmlPrinter.new(self)
        end

        # :nodoc:
        private def credential_scope
          CredentialScope.new(@credentials, @scope).to_s
        end

        # :nodoc:
        private def signature(policy)
          Signers::PostPolicy.new(policy, @credentials, @scope)
        end

        # :nodoc:
        private def bucket
          if bucket = fields.find { |field| field.key == "bucket" }
            bucket.value
          end
        end
      end
    end
  end
end
