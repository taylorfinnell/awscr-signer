require "./post_field"

module Awscr
  module Signer
    module Presigned
      # Holds a collection of `PostField`s.
      #
      # ```
      # fields = FieldCollection.new
      # fields.to_a # => [] of PostField
      # field["test"] = "test"
      # field.push(PostField.new("Hi", "Hi"))
      # ```
      class FieldCollection
        include Enumerable(PostField)

        def initialize
          @fields = [] of PostField
        end

        # Adds a new `PostField` to the collection.
        def push(field : PostField)
          return false if @fields.includes?(field)
          @fields << field
          true
        end

        # Iterate over the collection's fields.
        def each(&block)
          @fields.each do |field|
            yield field
          end
          nil
        end
      end
    end
  end
end
