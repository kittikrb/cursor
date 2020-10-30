require "kittikrb/cursor"

cursor = KittikRb::Cursor.create.reset_tty!

# It will print only 34567890 because you have negative X coordinate
cursor.move_to(-2, 1).write("1234567890").flush
