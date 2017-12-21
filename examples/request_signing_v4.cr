# Sign any Crystal HTTP::Request. Here we list S3 objects in a bucket.
require "../src/awscr-signer"

SERVICE = "s3"
BUCKET  = ENV["AWS_BUCKET"]
KEY     = ENV["AWS_KEY"]
SECRET  = ENV["AWS_SECRET"]
REGION  = ENV["AWS_REGION"]
HOST    = "#{BUCKET}.#{SERVICE}.amazonaws.com"

def client(host, &block)
  client = HTTP::Client.new(host)

  client.before_request do |request|
    signer = Awscr::Signer::Signers::V4.new(SERVICE, REGION, KEY, SECRET)
    signer.sign(request)
  end

  yield client
end

client(HOST) do |client|
  # Raw XML response for listing bucket contents.
  puts client.get("?list-type=2").body
end
