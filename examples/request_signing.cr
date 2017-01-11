# Sign any Crystal HTTP::Request. Here we list S3 objects in a bucket.
require "../src/awscr-signer"

BUCKET = ENV["AWS_BUCKET"]
HOST   = "#{BUCKET}.s3.amazonaws.com"
KEY    = ENV["AWS_KEY"]
SECRET = ENV["AWS_SECRET"]
REGION = ENV["AWS_REGION"]

def credentials
  Awscr::Signer::Credentials.new(KEY, SECRET)
end

def scope
  Awscr::Signer::Scope.new(REGION, "s3")
end

def client(host, &block)
  client = HTTP::Client.new(host)

  client.before_request do |request|
    request.headers["Host"] = HOST

    signer = Awscr::Signer::V4.new(request, scope, credentials)
    signer.sign
  end

  yield client
end

client(HOST) do |client|
  # Raw XML response for listing bucket contents.
  puts client.get("?list-type=2").body
end
