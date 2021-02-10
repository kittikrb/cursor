# Regular expression for capturing HEX channels.
# E.g. "#FFFFFF"

module KittikRb
  module Cursor
    module Color
      HEX_MARKER = "#"
      HEX_REGEX =
        /#(?<red>[0-9A-F]{2})(?<green>[0-9A-F]{2})(?<blue>[0-9A-F]{2})/i
    end
  end
end
