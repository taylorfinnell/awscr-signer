# awscr-signer
[![Build Status](https://travis-ci.org/taylorfinnell/awscr-signer.svg?branch=master)](https://travis-ci.org/taylorfinnell/awscr-signer)

Crystal interface for AWS Signing.

Supports signing or presigning Crystal `HTTP::Request` objects.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  awscr-signer:
    github: taylorfinnell/awscr-signer
```

## Usage

**Create a `Signer::Signers::V4` object.**
```crystal
signer = Awscr::Signer::Signers::V4.new("service", "region", "key", "secret")
```

or

**Create a `Signer::Signers::V2` object.**
```crystal
signer = Awscr::Signer::Signers::V2.new("service", "region", "key", "secret")
```

**Signing an `HTTP::Request`.**

```crystal
signer.sign(request)
```

**Signing an `String`.**

```crystal
signer.sign("my string")
```

**Presign a `HTTP::Request`.**

```crystal
signer.presign(request)
```

[Examples](https://github.com/taylorfinnell/awscr-signer/tree/master/examples)

S3
===

For S3 specific support see [awscr-s3](https://github.com/taylorfinnell/awscr-s3/).

Known Limitations
===

The following items are known issues.

- The request URI can not contain repeating slashes.
- The request headers can not have new line separted values.
- The request path can not contain spaces.

