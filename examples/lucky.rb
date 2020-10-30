require "kittikrb/cursor"

cursor = KittikRb::Cursor.create.reset_tty!
COLORS = [:red, :silver, :yellow, :green, :blue].cycle
TEXT = "Always after me lucky charms.".chars.cycle

loop do
  y, dy = 0, 1

  0.upto(40) do |i|
    cursor.move_by(1, dy).foreground(COLORS.next).write(TEXT.next)
    y += dy
    dy *= -1 if y <= 0 || y >= 5
  end

  cursor.move_to(0, 0).flush

  sleep 0.15
end
