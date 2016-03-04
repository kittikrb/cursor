require 'kittikrb/cursor'

cursor = KittikRb::Cursor.create.reset_tty!
cursor.write('HELLO').flush
