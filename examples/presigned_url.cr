require "../src/awscr-signer"
require "secure_random"

BUCKET = ENV["AWS_BUCKET"]
HOST   = "#{BUCKET}.s3.amazonaws.com"
KEY    = ENV["AWS_KEY"]
SECRET = ENV["AWS_SECRET"]
REGION = ENV["AWS_REGION"]

creds = Awscr::Signer::Credentials.new(KEY, SECRET)
scope = Awscr::Signer::Scope.new(REGION, "s3")

object = "/#{SecureRandom.uuid}.txt"

options = Awscr::Signer::Presigned::Url::Options.new(
  "/#{SecureRandom.uuid}.txt", BUCKET)
url = Awscr::Signer::Presigned::Url.new(scope, creds, options)
HTTP::Client.put(url.for(:put), HTTP::Headers.new, body: "Howdy!")

# get it back
resp = HTTP::Client.get(url.for(:get))
p resp.body
