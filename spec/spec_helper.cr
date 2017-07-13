require "spec"
require "../src/awscr-signer"
require "timecop"

# Monkey patch Time\Timecop
struct Time
  def self.utc_now
    Timecop.now
  end
end
