# awscr-signer
[![Build Status](https://travis-ci.org/taylorfinnell/awscr-signer.svg?branch=master)](https://travis-ci.org/taylorfinnell/awscr-signer)

Crystal interface for AWS Signing.

Supports signing Crytal `HTTP::Request` objects and generating presigned post form for browser or programatic uploading. See [Browser-Based Uploads Using POST](http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-UsingHTTPPOST.html) and [Authenticating Requests (AWS Signature Version 4)](http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html) for additional details.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  awscr-signer:
    github: taylorfinnell/awscr-signer
```

## Usage

[Examples](https://github.com/taylorfinnell/awscr-signer/tree/master/examples)

Known Limitations
===

The following items are known issues. 

- The request URI can not contain repeating slashes
- The request headers can not have new line separted values
- The request path can not contain spaces

