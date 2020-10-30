require "kittikrb/cursor"

cursor = KittikRb::Cursor.create.reset_tty!

cursor
  .bold
  .write("BOLD")
  .bold(false)
  .move_by(-4, 1)
  .dim
  .write("DIM")
  .dim(false)
  .move_by(-3, 1)
  .underlined
  .write("UNDERLINED")
  .underlined(false)
  .move_by(-10, 1)
  .blink
  .write("BLINK")
  .blink(false)
  .move_by(-5, 1)
  .reverse
  .write("REVERSE")
  .reverse(false)
  .move_by(-7, 1)
  .hidden
  .write("HIDDEN")
  .hidden(false)
  .flush
