require 'kittikrb/cursor'

cursor = KittikRb::Cursor.create.reset_tty!

RADIUS = 10
COLORS = [:red, :yellow, :green, :olive, :blue, :magenta]

points = []
theta = 0

loop do
  x = 2 + (RADIUS + Math.cos(theta) * RADIUS) * 2
  y = 2 + RADIUS + Math.sin(theta) * RADIUS

  points.unshift([x, y])
  points.each_with_index do |p, i|
    cursor.move_to(*p)
    cursor.background(COLORS[(i / 12).floor]).write(' ').flush
  end

  points = points.slice(0, 12 * COLORS.size - 1)
  theta += Math::PI / 40

  sleep 0.001
end
