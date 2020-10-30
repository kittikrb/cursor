module KittikRb
  module Cursor
    class Cell
      DISPLAY_CONFIG = {
        bold: false,
        dim: false,
        underlined: false,
        blink: false,
        reverse: false,
        hidden: false
      }

      attr_reader :char
      attr_accessor :x, :y

      def initialize(char = " ", options = {})
        @char = char
        @x, @y = options[:x], options[:y]
      end
    end
  end
end
