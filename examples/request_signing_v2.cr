# Sign any Crystal HTTP::Request. Here we list S3 objects in a bucket.
require "../src/awscr-signer"

Log.setup_from_env

SERVICE = "s3"
BUCKET  = ENV.fetch("AWS_BUCKET", "examplebucket")
KEY     = ENV.fetch("AWS_KEY", "AKIAIOSFODNN7EXAMPLE")
SECRET  = ENV.fetch("AWS_SECRET", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")
REGION  = ENV.fetch("AWS_REGION", "us-east-1")
HOST    = "#{BUCKET}.#{SERVICE}.amazonaws.com"

def client(host, &)
  client = HTTP::Client.new(host)

  client.before_request do |request|
    signer = Awscr::Signer::Signers::V2.new(SERVICE, REGION, KEY, SECRET)
    signer.sign(request)
  end

  yield client
end

client(HOST) do |client|
  # Raw XML response for listing bucket contents.
  puts client.get("?list-type=2").body
end
