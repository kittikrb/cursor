require 'kittikrb/cursor/version'
require 'kittikrb/cursor/colors'
require 'kittikrb/cursor/display_modes'

require 'set'
require 'io/console'

##
# Cursor implements low-level API to terminal control codes.
# See links below for details:
# http://www.termsys.demon.co.uk/vtansi.htm
# http://misc.flogisoft.com/bash/tip_colors_and_formatting
# http://man7.org/linux/man-pages/man4/console_codes.4.html
# http://www.x.org/docs/xterm/ctlseqs.pdf

module KittikRb
  module Cursor

    def self.create
      Cursor.new
    end

    class Cursor
      include KittikRb::Cursor::Colors
      include KittikRb::Cursor::DisplayModes

      DISPLAY_CONFIG = {
        bold: false,
        dim: false,
        underlined: false,
        blink: false,
        reverse: false,
        hidden: false
      }
      ESCAPE_CHAR = "\e"

      # Only for compatibility with KittikJs API
      def self.encode_to_vt100(str)
        ESCAPE_CHAR + str
      end

      # Creates cursor that writes direct to `stdout`
      def initialize
        @height, @width = $stdout.winsize
        @x, @y = 0, 0
        @background, @foreground = false, false
        @display = DISPLAY_CONFIG

        init_buffers!
      end

      def write_control(str)
        $stdout.write(ESCAPE_CHAR + str)
      end

      # Reset all terminal settings.
      # Applies immediately without calling flush.
      def reset_tty!
        write_control 'c'
        self
      end

      private
      ########################################################################

      def init_buffers!
        @buffer = Array.new(@width * @height, ' ')
        @rendered_buffer = Set.new(@buffer)
      end
    end
  end
end
