require "kittikrb/cursor"

cursor = KittikRb::Cursor.create.reset_tty!
height, width = $stdout.winsize

COLORS = KittikRb::Cursor::Colors::COLORS.keys

0.upto height do |y|
  0.upto width do |x|
    cursor.move_to(x, y)
      .background(COLORS[(y + x) % (COLORS.size - 1)]).write(" ")
  end
end

cursor.flush
