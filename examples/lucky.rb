require 'kittikrb/cursor'

def set_interval(delay)
  Thread.new do
    loop do
      sleep delay

      yield
    end
  end.join
end

cursor = KittikRb::Cursor.create.reset_tty!
COLORS = [:red, :silver, :yellow, :green, :blue].cycle
TEXT = 'Always after me lucky charms.'.chars.cycle

set_interval(0.15) do
  y, dy = 0, 1

  0.upto(40) do |i|
    cursor.move_by(1, dy).foreground(COLORS.next).write(TEXT.next)
    y += dy
    dy *= -1 if y <= 0 || y >= 5
  end

  cursor.move_to(0, 0).flush
end
