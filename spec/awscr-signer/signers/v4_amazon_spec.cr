require "../../spec_helper"

module Awscr
  module Signer
    module Signers
      def self.assert_request_signed(request : HTTP::Request, expected_auth_header : String)
        signer = V4.new("service", "us-east-1", "AKIDEXAMPLE", "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
        signer.sign(request, add_sha: false)

        request.headers["Authorization"].should eq(expected_auth_header)
      end

      describe V4 do
        describe "signing an HTTP::Request" do
          time = Time.unix(1440938160)

          it "get-header-key-duplicate" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/", HTTP::Headers.new)

              request.headers.add("My-Header1", "value2")
              request.headers.add("My-Header1", "value2")
              request.headers.add("My-Header1", "value1")
              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;my-header1;x-amz-date, Signature=c9d5ea9f3f72853aea855b47ea873832890dbdd183b4468f858259531a5138ea")
            end
          end

          pending "get-header-value-multiline" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/", HTTP::Headers.new)

              request.headers.add("My-Header1", "value1\n   \n  value2  \nvalue3")
              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;my-header1;x-amz-date, Signature=ba17b383a53190154eb5fa66a1b836cc297cc0a3d70a5d00705980573d8ff790")
            end
          end

          it "get-header-value-order" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/", HTTP::Headers.new)

              request.headers.add("My-Header1", "value4")
              request.headers.add("My-Header1", "value1")
              request.headers.add("My-Header1", "value3")
              request.headers.add("My-Header1", "value2")
              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;my-header1;x-amz-date, Signature=08c7e5a9acfcfeb3ab6b2185e75ce8b1deb5e634ec47601a50643f830c755c01")
            end
          end

          it "get-header-value-trim" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/", HTTP::Headers.new)

              request.headers.add("My-Header1", "value1")
              request.headers.add("My-Header2", "\"a   b   c\"")
              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;my-header1;my-header2;x-amz-date, Signature=acc3ed3afb60bb290fc8d2dd0098b9911fcaa05412b367055dee359757a9c736")
            end
          end

          it "get-unreserved" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/-._~0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=07ef7494c76fa4850883e2b006601f940f8a34d404d0cfa977f52a65bbf5f24f")
            end
          end

          it "get-utf8" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/ሴ", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=8318018e0b0f223aa2bbf98705b62bb787dc9c0e678f255a891fd03141be5d85")
            end
          end

          it "get-vanilla-empty-query-key" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/?Param1=value1", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=a67d582fa61cc504c4bae71f336f98b97f1ea3c7a6bfe1b6e45aec72011b9aeb")
            end
          end

          it "get-vanilla-query-order-key-case" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/?Param1=value1&Param2=value2", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=b97d918cfa904a5beff61c982a1b6f458b799221646efd99d3219ec94cdf2500")
            end
          end

          it "get-vanilla-query-unreserved" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/?-._~0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz=-._~0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=9c3e54bfcdf0b19771a7f523ee5669cdf59bc7cc0884027167c21bb143a40197")
            end
          end

          it "get-vanilla-query" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=5fa00fa31553b73ebf1942676e86291e8372ff2a2260956d9b8aae1d763fbf31")
            end
          end

          it "get-vanilla-utf8" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/?ሴ=bar", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=2cdec8eed098649ff3a119c94853b13c643bcf08f8b0a1d91e12c9027818dd04")
            end
          end

          it "get-vanilla" do
            with_time_freeze(time) do
              request = HTTP::Request.new("GET", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=5fa00fa31553b73ebf1942676e86291e8372ff2a2260956d9b8aae1d763fbf31")
            end
          end

          describe "normalized path" do
            it "get-relative" do
              with_time_freeze(time) do
                request = HTTP::Request.new("GET", "/example/..", HTTP::Headers.new)

                request.headers.add("Host", "example.amazonaws.com")
                request.headers.add("X-Amz-Date", "20150830T123600Z")
                request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

                assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=5fa00fa31553b73ebf1942676e86291e8372ff2a2260956d9b8aae1d763fbf31")
              end
            end

            it "get-relative-relative" do
              with_time_freeze(time) do
                request = HTTP::Request.new("GET", "/example1/example2/../..", HTTP::Headers.new)

                request.headers.add("Host", "example.amazonaws.com")
                request.headers.add("X-Amz-Date", "20150830T123600Z")
                request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

                assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=5fa00fa31553b73ebf1942676e86291e8372ff2a2260956d9b8aae1d763fbf31")
              end
            end

            it "get-slash-dot-slash" do
              with_time_freeze(time) do
                request = HTTP::Request.new("GET", "/./", HTTP::Headers.new)

                request.headers.add("Host", "example.amazonaws.com")
                request.headers.add("X-Amz-Date", "20150830T123600Z")
                request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

                assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=5fa00fa31553b73ebf1942676e86291e8372ff2a2260956d9b8aae1d763fbf31")
              end
            end

            it "get-slash-pointless-dot" do
              with_time_freeze(time) do
                request = HTTP::Request.new("GET", "/./example", HTTP::Headers.new)

                request.headers.add("Host", "example.amazonaws.com")
                request.headers.add("X-Amz-Date", "20150830T123600Z")
                request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

                assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=ef75d96142cf21edca26f06005da7988e4f8dc83a165a80865db7089db637ec5")
              end
            end

            it "get-slash" do
              with_time_freeze(time) do
                request = HTTP::Request.new("GET", "//", HTTP::Headers.new)

                request.headers.add("Host", "example.amazonaws.com")
                request.headers.add("X-Amz-Date", "20150830T123600Z")
                request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

                assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=5fa00fa31553b73ebf1942676e86291e8372ff2a2260956d9b8aae1d763fbf31")
              end
            end

            pending "get-slashes" do
              with_time_freeze(time) do
                request = HTTP::Request.new("GET", "//example//", HTTP::Headers.new)

                request.headers.add("Host", "example.amazonaws.com")
                request.headers.add("X-Amz-Date", "20150830T123600Z")
                request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

                assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=9a624bd73a37c9a373b5312afbebe7a714a789de108f0bdfe846570885f57e84")
              end
            end

            it "get-space" do
              with_time_freeze(time) do
                request = HTTP::Request.new("GET", "/example space/", HTTP::Headers.new)

                request.headers.add("Host", "example.amazonaws.com")
                request.headers.add("X-Amz-Date", "20150830T123600Z")
                request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

                assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=652487583200325589f1fba4c7e578f72c47cb61beeca81406b39ddec1366741")
              end
            end
          end

          it "post-header-key-case" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=5da7c1a2acd57cee7505fc6676e4e544621c30862966e37dddb68e92efbe5d6b")
            end
          end

          it "post-header-key-sort" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.add("My-Header1", "value1")
              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;my-header1;x-amz-date, Signature=c5410059b04c1ee005303aed430f6e6645f61f4dc9e1461ec8f8916fdf18852c")
            end
          end

          it "post-header-value-case" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.add("My-Header1", "VALUE1")
              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;my-header1;x-amz-date, Signature=cdbc9802e29d2942e5e10b5bccfdd67c5f22c7c4e8ae67b53629efa58b974b7d")
            end
          end

          describe "with sts token" do
            pending "post-sts-header-after" do
            end

            pending "post-sts-header-before" do
            end
          end

          it "post-vanilla-empty-query-value" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/?Param1=value1", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=28038455d6de14eafc1f9222cf5aa6f1a96197d7deb8263271d420d138af7f11")
            end
          end

          it "post-vanilla-query-nonunreserved" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              request.query_params.add("@#$%^&+", "/,?><`\";:\\|][{}")

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=88d3e39e4fa54b971f51c0a09140368e1a51aafb76c4652d9998f93cf3038074")
            end
          end

          pending "post-vanilla-query-space" do
          end

          it "post-vanilla-query" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/?Param1=value1", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=28038455d6de14eafc1f9222cf5aa6f1a96197d7deb8263271d420d138af7f11")
            end
          end

          it "post-vanilla" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=host;x-amz-date, Signature=5da7c1a2acd57cee7505fc6676e4e544621c30862966e37dddb68e92efbe5d6b")
            end
          end

          it "post-x-www-form-urlencoded-parameters" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.add("Content-Type", "application/x-www-form-urlencoded; charset=utf8")

              request.body = "Param1=value1"

              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=1a72ec8f64bd914b0e42e42607c7fbce7fb2c7465f63e3092b3b0d39fa77a6fe")
            end
          end

          it "post-x-www-form-urlencoded" do
            with_time_freeze(time) do
              request = HTTP::Request.new("POST", "/", HTTP::Headers.new)

              request.headers.add("Host", "example.amazonaws.com")
              request.headers.add("X-Amz-Date", "20150830T123600Z")
              request.headers.add("Content-Type", "application/x-www-form-urlencoded")

              request.body = "Param1=value1"

              request.headers.delete("Content-Length") # b/c HTTP::Request.new adds it

              assert_request_signed(request, "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=ff11897932ad3f4e8b18135d722051e5ac45fc38421b1da7b9d196a0fe09473a")
            end
          end
        end
      end
    end
  end
end
