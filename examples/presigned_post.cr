require "../src/awscr-signer"
require "secure_random"

BUCKET = ENV["AWS_BUCKET"]
HOST   = "#{BUCKET}.s3.amazonaws.com"
KEY    = ENV["AWS_KEY"]
SECRET = ENV["AWS_SECRET"]
REGION = ENV["AWS_REGION"]

creds = Awscr::Signer::Credentials.new(KEY, SECRET)
form = Awscr::Signer::Presigned::Post.new(REGION, creds)

form.build do |builder|
  builder.expiration(Time.epoch(Time.now.epoch + 1000))
  builder.eq("bucket", BUCKET)
  builder.eq("key", SecureRandom.uuid)
  builder.eq("success_action_status", 201)
end

# The following HTML represents a valid form. Try writing the
# HTML to a file and opening it in your browser. You will be
# presented with a small upload form to upload directly from
# your browser.
#
# You may access the fields via form#fields.
# You may access the url via form#url.
puts form.to_html
