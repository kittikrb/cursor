require_relative "named_colors"
require_relative "hex_color"
require_relative "rgb_color"
require_relative "color_error"

# Differences from KittikJS:
# - doesn't provide factory methods for the Color class, use new instead
# - doesn't throw format-specific error messages

module KittikRb
  module Cursor
    module Color
      class Color
        class << self
          def named?(color)
            NAMED_COLORS.key?(color.downcase.to_sym)
          end

          def hex?(color)
            !!color[HEX_REGEX]
          end

          def rgb?(color)
            !!color[RGB_REGEX]
          end
        end

        def initialize(color)
          parsed_color =
            color.respond_to?(:match) ? parse_color(color) : color

          raise_error!(color) unless parsed_color&.values&.all?

          @r = @g = @b = 0

          r(parsed_color[:r])
          g(parsed_color[:g])
          b(parsed_color[:b])
        end

        def r(color = nil)
          return @r unless color

          @r = bound_color(color.to_i)

          self
        end

        def g(color = nil)
          return @g unless color

          @g = bound_color(color.to_i)

          self
        end

        def b(color = nil)
          return @b unless color

          @b = bound_color(color.to_i)

          self
        end

        def to_rgb
          make_color(r, g, b)
        end

        def to_hex
          make_hex_color(r, g, b)
        end

        private

        def raise_error!(color)
          raise ColorError, "Color '#{color}' can't be parsed"
        end

        def parse_color(color)
          return parse_rgb(color) if color.start_with?(RGB_MARKER)
          return parse_hex(color) if color.start_with?(HEX_MARKER)

          parse_hex(named_color(color))
        end

        def bound_color(color)
          [0, [color, 255].min].max
        end

        def parse_hex(color)
          hex_color = HEX_REGEX.match(color)

          hex_color && make_color(
            hex_color[:red].to_i(16),
            hex_color[:green].to_i(16),
            hex_color[:blue].to_i(16)
          )
        end

        def parse_rgb(color)
          rgb_color = RGB_REGEX.match(color)

          rgb_color && make_color(
            rgb_color[:red].to_i,
            rgb_color[:green].to_i,
            rgb_color[:blue].to_i
          )
        end

        def make_color(r, g, b)
          {r: r, g: g, b: b}
        end

        def make_hex_color(r, g, b)
          sprintf("#%02x%02x%02x", r, g, b)
        end

        def named_color(color)
          NAMED_COLORS[color.downcase.to_sym]
        end
      end
    end
  end
end
