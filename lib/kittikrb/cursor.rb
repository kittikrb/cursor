require "kittikrb/cursor/core_patches/hash"

require "kittikrb/cursor/version"
require "kittikrb/cursor/colors"
require "kittikrb/cursor/display_modes"

require "kittikrb/cursor/cell"

require "set"
require "io/console"

##
# Cursor implements low-level API to terminal cursor.
# See links below for details:
# http://www.termsys.demon.co.uk/vtansi.htm
# http://misc.flogisoft.com/bash/tip_colors_and_formatting
# http://man7.org/linux/man-pages/man4/console_codes.4.html
# http://www.x.org/docs/xterm/ctlseqs.pdf

module KittikRb
  module Cursor
    using CorePatches::HashPatch

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

      def self.encode_to_vt100(str)
        ESCAPE_CHAR + str
      end

      # Wrap char with all control codes needed for rendering the cell.
      # Returns ready to flush string with ASCII control codes
      def self.wrap(char, options = {})
        wrap_position(options[:x], options[:y]) <<
          wrap_ground_colors(options.slice(:background, :foreground)) <<
          wrap_display_modes(options[:display] || {}) <<
          char <<
          wrap_display_modes(reset_all: true)
      end

      def initialize
        @height, @width = $stdout.winsize
        @x, @y = 0, 0
        @background, @foreground = false, false
        @display = DISPLAY_CONFIG
        @buffer = Array.new(@width * @height, " ")
        update_rendered_buffer!
      end

      # Build control sequence for each cell in data and write it to the buffer.
      def write(data)
        data.chars.each do |char|
          if cursor_in_bounding_box?
            options = {x: @x, y: @y,
                       background: @background,
                       foreground: @foreground,
                       display: @display}
            @buffer[get_pointer_from_xy] = self.class.wrap char, options
          end

          @x += 1
        end

        self
      end

      # Build difference between current buffer and rendered buffer and write
      # it to TTY. Difference contains new control codes only, optimizing
      # the rendering performance.
      def flush
        $stdout.write(@buffer.select { |c| !@rendered_buffer.include?(c) }.join)
        update_rendered_buffer!

        self
      end

      # Get index of the buffer from (x, y) coordinates.
      def get_pointer_from_xy(x = @x, y = @y)
        y * @width + x
      end

      # Get (x, y) coordinate from the buffer pointer.
      def get_xy_from_pointer(index)
        [index - (index / @width).floor * @width, (index / @width).floor]
      end

      def move_to(x, y)
        @x, @y = x.floor, y.floor

        self
      end

      def move_by(x, y)
        x > 0 ? right(x) : left(x.abs)
        y > 0 ? down(y) : up(y.abs)

        self
      end

      def up(y = 1)
        @y -= y.floor

        self
      end

      def down(y = 1)
        @y += y.floor

        self
      end

      def left(x = 1)
        @x -= x.floor

        self
      end

      def right(x = 1)
        @x += x.floor

        self
      end

      # Erase the specified region.
      # The region describes the rectangle shape which need to erase.
      def erase(x1, y1, x2, y2)
        y1.floor.upto(y2.floor) do |y|
          x1.floor.upto(x2.floor) do |x|
            @buffer[get_pointer_from_xy(x, y)] = self.class.wrap " ", {x: x,
                                                                       y: y}
          end
        end

        self
      end

      # Erase from current position to end of the line.
      def erase_to_end
        erase @x, @y, @width - 1, @y

        self
      end

      # Erase from current position to start of the line.
      def erase_to_start
        erase 0, @y, @x, @y

        self
      end

      # Erase from current line to down.
      def erase_to_down
        erase 0, @y, @width - 1, @height - 1

        self
      end

      # Erase from current line to up.
      def erase_to_up
        erase 0, 0, @width - 1, @y

        self
      end

      def erase_line
        erase 0, @y, @width - 1, @y

        self
      end

      def erase_screen
        erase 0, 0, @width - 1, @height - 1

        self
      end

      def foreground(color)
        @foreground = color

        self
      end

      def background(color)
        @background = color

        self
      end

      def bold(is_bold = true)
        @display[:bold] = is_bold

        self
      end

      def dim(is_dim = true)
        @display[:dim] = is_dim

        self
      end

      def underlined(is_underlined = true)
        @display[:underlined] = is_underlined

        self
      end

      def blink(is_blink = true)
        @display[:blink] = is_blink

        self
      end

      def reverse(is_reverse = true)
        @display[:reverse] = is_reverse

        self
      end

      def hidden(is_hidden = true)
        @display[:hidden] = is_hidden

        self
      end

      def hide_cursor
        write_control("[?25l")

        self
      end

      def show_cursor
        write_control("[?25h")

        self
      end

      def write_control(str)
        $stdout.write(ESCAPE_CHAR + str)
      end

      # Reset all terminal settings.
      # Applies immediately without calling flush.
      def reset_tty!
        write_control "c"

        self
      end

      private

      ########################################################################

      def self.wrap_position(x, y)
        ESCAPE_CHAR + "[#{(y + 1).floor};#{(x + 1).floor}f"
      end
      private_class_method :wrap_position

      def self.wrap_ground_colors(foreground: nil, background: nil)
        [(ESCAPE_CHAR + "[48;5;#{COLORS[background]}m" if background),
          (ESCAPE_CHAR + "[38;5;#{COLORS[foreground]}m" if foreground)].join
      end
      private_class_method :wrap_ground_colors

      def self.wrap_display_modes(options = {})
        DISPLAY_MODES.map { |key, value|
          ESCAPE_CHAR + "[#{DISPLAY_MODES[key]}m" if options[key]
        }.join
      end
      private_class_method :wrap_display_modes

      def update_rendered_buffer!
        @rendered_buffer = Set.new(@buffer)
      end

      def cursor_in_bounding_box?
        0 <= @x && @x < @width && 0 <= @y && @y < @height
      end
    end
  end
end
