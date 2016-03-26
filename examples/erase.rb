require 'kittikrb/cursor'

def sleep_for_one_second
  sleep 1
end

cursor = KittikRb::Cursor.create.reset_tty!.hide_cursor
height, width = $stdout.winsize

0.upto height do |y|
  cursor.move_to(0, y).write('E' * width)
end

cursor.move_to(width / 2, height / 2).flush

sleep_for_one_second
cursor.erase_to_start.flush

sleep_for_one_second
cursor.erase_to_end.flush

sleep_for_one_second
cursor.erase_to_up.flush

sleep_for_one_second
cursor.erase_to_down.flush

sleep_for_one_second
cursor.erase_screen.flush.show_cursor
