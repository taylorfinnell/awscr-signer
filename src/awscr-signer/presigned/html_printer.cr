module Awscr
  module Signer
    module Presigned
      # Print a `Presigned::Post` object as RAW HTML.
      class HtmlPrinter
        def initialize(post : Post)
          @post = post
        end

        def to_s(io : IO)
          io << print
        end

        # Print a `Presigned::Post` object as RAW HTML.
        def print
          br = "<br />"

          inputs = @post.fields.map do |field|
            <<-INPUT
            <input type="hidden" name="#{field.key}" value="#{field.value.join}" />
            INPUT
          end

          <<-HTML
          <form action="#{@post.url}" method="post" enctype="multipart/form-data">
          #{inputs.join(br)}

            <input type="file"   name="file" /> <br />
            <input type="submit" name="submit" value="Upload" />
          </form>
          HTML
        end
      end
    end
  end
end
