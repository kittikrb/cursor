require "kittikrb/cursor"

cursor = KittikRb::Cursor.create.reset_tty!

cursor
  .move_to(15, 5)
  .write("move_to")
  .move_by(15, 5)
  .write("move_by")
  .down(5)
  .write("down")
  .up(10)
  .write("up")
  .left(20)
  .write("left")
  .right(40)
  .write("right")
  .down(10)
  .flush
