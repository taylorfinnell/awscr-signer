require "spec"
require "../src/awscr-signer"
require "timecop"

Timecop.safe_mode = true

def self.with_time_freeze(time, &block)
  Timecop.freeze(time) do
    block.call
  end
end
