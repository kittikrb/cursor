module KittikRb
  module Cursor
    module DisplayModes

      ##
      # Map of the display modes that can be used in Cursor API.
      # There are the most commonly supported control sequences for formatting
      # text and their resetting.

      DISPLAY_MODES = {
        reset_all: 0,
        bold: 1,
        dim: 2,
        underlined: 4,
        blink: 5,
        reverse: 7,
        hidden: 8,
        reset_bold: 21,
        reset_dim: 22,
        reset_underlined: 24,
        reset_blink: 25,
        reset_reverse: 27,
        reset_hidden: 28
      }
    end
  end
end
