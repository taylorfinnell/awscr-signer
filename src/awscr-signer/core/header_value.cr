module Awscr
  module Signer
    # Create a value for a `Header`.
    #
    # ```
    # header = HeaderValue.new("1")
    # header.to_s # => "1"
    # ```
    #
    # ```
    # header = HeaderValue.new("1,2")
    # header.merge("3")
    # header.to_s # => "1,2,3"
    # ```
    class HeaderValue
      @values = [] of String

      # Create a header value from an array of values
      def initialize(values : Array(String))
        values.each { |v| merge(v) }
      end

      # Create a header value from a single string
      def initialize(value : String)
        merge(value)
      end

      # Merge another value into this value.
      def merge(value)
        values = extract_values(value)
        values.each do |v|
          @values.push(clean_value(v))
        end
        values.any?
      end

      # Return the header as a string
      def to_s(io : IO)
        io << @values.join(",")
      end

      private def clean_value(value)
        value.strip.gsub(/(\s)+/, " ")
      end

      private def extract_values(value : String)
        value.split("\n").flat_map { |line| line.split(",") }
      end
    end
  end
end
