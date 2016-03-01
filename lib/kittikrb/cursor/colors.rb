module KittikRb
  module Cursor
    module Colors

      ##
      # Now mapped only basic 16 colors.
      # Here are the control sequences that permit you to use them.
      # Some terminals can support 256 colors.
      #
      # The colors number 256 is only supported by vte (GNOME Terminal, XFCE4
      # Terminal, Nautilus Terminal, Terminator, ...)

      COLORS = {
        black: 0,
        maroon: 1,
        green: 2,
        olive: 3,
        navy_blue: 4,
        purple: 5,
        teal: 6,
        silver: 7,
        grey: 8,
        red: 9,
        lime: 10,
        yellow: 11,
        blue: 12,
        magenta: 13,
        aqua: 14,
        white: 15
      }
    end
  end
end
