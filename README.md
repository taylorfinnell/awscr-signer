# awscr-signer

Crystal interface for signing requests according to the AWS V4 signing spec. Can be used
across AWS regions and services.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  awscr-signer:
    github: taylorfinnell/awscr-signer
```

## Usage

You may sign a Crystal `HTTP::Request`.

```crystal
require "awscr-signer"

request = HTTP::Request.new("GET", "/", HTTP::Headers.new)

scope  = Awscr::Signer::Scope.new("AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY", "us-east-1", "service")
signer = Awscr::Signer::V4.new(request, scope)
signer.sign

puts request.headers["Authorization"] # the authorization header is set
```

A small S3 "client" that demonstrates usage.

```crystal
require "awscs-signer"

HOST = "mybucket.s3.amazonaws.com"

scope  = Awscr::Signer::Scope.new("AKIDEXAMPLE",
          "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY", "us-east-1", "service")

def client(host, &block)
  client = HTTP::Client.new(host)

  client.before_request do |request|
    request.headers["Host"] = HOST
    signer = Awscr::Signer::V4.new(request, scope)
    signer.sign
  end

  yield client
end

client(HOST) do |client|
  puts client.get("?acl").body
  puts client.get("?list-type=2").body
end
```

Known Limitations
===

The following items are known issues. A client using this library can ensure
these headers are never signed as a work around until they get fixed.

- Relative paths are not supported ie: `/example/..`
- Certain slashes in the URI path ie: `//example//`, `//`
- Newline separated values
- Spaces in the path ie: `/example stuff/`

Development
===

The code attempts to mimic the various parts described in the documentation [here](http://docs.awscr.amazon.com/AmazonS3/latest/API/images/sigV4-auth-header-chunked-seed-signature.png)
