module KittikRb
  module Cursor
    module VT100
      def encode_to_vt100(code)
        "\e#{code}"
      end
    end
  end
end
