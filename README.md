# awscr-signer
[![CircleCI](https://circleci.com/gh/taylorfinnell/awscr-signer.svg?style=svg)](https://circleci.com/gh/taylorfinnell/awscr-signer)

Crystal interface for AWS Signing.

Supports signing Crystal `HTTP::Request` objects and generating presigned post form for browser or programmatic uploading. See [Browser-Based Uploads Using POST](http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-UsingHTTPPOST.html) and [Authenticating Requests (AWS Signature Version 4)](http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html) for additional details.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  awscr-signer:
    github: taylorfinnell/awscr-signer
```

## Usage

**Creating a `Credentials` object.**

```crystal
  Awscr::Signer::Credentials.new("SECRET_KEY", "SECRET")
```

**Creating a `Scope` object.**

```crystal
  # where s3 is any amazon service
  # where us-east-1 is any region
  Awscr::Signer::Scope.new("us-east-1", "s3")
```

**Signing an `HTTP::Request`.**

```crystal
signer = Awscr::Signer::V4.new(scope, credentials)
signer.sign_request(request)
```

***NOTE**: It may be required for you to set the `Host` header to the AWS service
before signing.*

**Creating a `Presigned::Form`.**

```crystal
form = Awscr::Signer::Presigned::Form.build("us-east-1", credentials) do |form|
  form.expiration(Time.epoch(Time.now.epoch + 1000))
  form.condition("bucket", BUCKET)
  form.condition("acl", "public-read")
  form.condition("key", SecureRandom.uuid)
  form.condition("Content-Type", "text/plain")
  form.condition("success_action_status", "201")
end
```

**Converting the form to raw HTML (for browser uploads, etc).**

```crystal
puts form.to_html
```

**Submitting the form via `HTTP::Client`.**

```crystal
form.submit(IO::Memory.new("Hello, S3!"))
```

[Examples](https://github.com/taylorfinnell/awscr-signer/tree/master/examples)

Known Limitations
===

The following items are known issues. 

- The request URI can not contain repeating slashes.
- The request headers can not have new line separted values.
- The request path can not contain spaces.

