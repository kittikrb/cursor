# Regular expression for capturing RGB channels.
# E.g. "rgb(0, 0, 0)"

module KittikRb
  module Cursor
    module Color
      RGB_MARKER = "rgb"
      RGB_REGEX =
        /rgb\((?<red>\d{1,3}), (?<green>\d{1,3}), (?<blue>\d{1,3})\)/i
    end
  end
end
