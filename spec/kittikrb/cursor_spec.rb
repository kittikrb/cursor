require 'spec_helper'

describe KittikRb::Cursor do
  it 'has a version number' do
    expect(KittikRb::Cursor::VERSION).not_to be nil
  end

  describe '#create' do
    it 'should create a new instance of KittikRb::Cursor::Cursor' do
      expect(KittikRb::Cursor.create).
        to be_instance_of KittikRb::Cursor::Cursor
    end
  end

  describe KittikRb::Cursor::Cursor do
    let!(:cursor) { KittikRb::Cursor::Cursor.new }

    describe '#self.encode_to_vt100' do
      it 'should properly encode to VT100 compatible symbol' do
        expect(described_class.encode_to_vt100('c')).to eq "\ec"
      end
    end

    describe '#self.wrap' do
      let(:x) { 0 }
      let(:y) { 0 }
      let(:display) { { bold: true, underlined: true } }

      it 'should properly wrap the char with control sequence' do
        expect(described_class.wrap(' ', x: x, y: y)).to eq "\e[1;1f \e[0m"
        expect(described_class.wrap(' ', x: x, y: y, background: :black)).
          to eq "\e[1;1f\e[48;5;0m \e[0m"
        expect(described_class.wrap(' ', x: x, y: y, foreground: :white)).
          to eq "\e[1;1f\e[38;5;15m \e[0m"
        expect(described_class.wrap(' ', x: x, y: y, display: display)).
          to eq "\e[1;1f\e[1m\e[4m \e[0m"
      end
    end

    describe 'new cursor instance' do
      let(:default_buffer) { Array.new(2 * 2, ' ') }
      let!(:default_values) { {
        width: $stdout.winsize[1],
        height: $stdout.winsize[0],
        x: 0,
        y: 0,
        background: false,
        foreground: false,
        display: described_class::DISPLAY_CONFIG,
        buffer: default_buffer,
        rendered_buffer: Set.new(cursor.instance_variable_get(:@buffer))
      } }

      it 'should be initialized with default values' do
        cursor.instance_variable_set(:@buffer, default_buffer)
        default_values.each do |key, value|
          expect(cursor.instance_variable_get("@#{key}")).to eq(value)
        end
      end
    end

    describe '#write' do
      let(:data) { 'test' }
      def check_buffer_data
        buffer = cursor.instance_variable_get(:@buffer)
        data.chars.each_with_index do |char, i|
          expect(buffer[i]).to eq "\e[1;#{i + 1}f#{char}\e[0m"
        end
      end

      it 'should properly write to the buffer' do
        expect(cursor.write(data)).to be_instance_of described_class
        check_buffer_data
      end

      it 'should properly ignore write if out of the bounding box' do
        cursor.write(data)
        check_buffer_data

        cursor.move_to(-5, -5).write('do not print')
        check_buffer_data

        expect(cursor.instance_variable_get(:@buffer)[4]).to eq ' '
      end
    end

    describe '#flush' do
      def current_rendered_buffer
        cursor.instance_variable_get(:@rendered_buffer)
      end

      it 'should flush the buffer into the stream, update rendered buffer '\
         'and return self' do
        prev_rendered_buffer = current_rendered_buffer
        expect($stdout).to receive(:write)
        cursor.write('test flush')
        expect(cursor.flush).to be_instance_of described_class
        expect(current_rendered_buffer).not_to eq prev_rendered_buffer
      end
    end

    describe '#get_pointer_from_xy' do
      it 'should properly calculate buffer pointer' do
        expect(cursor.get_pointer_from_xy).to eq 0
        cursor.move_to(10, 10)
        expect(cursor.get_pointer_from_xy).to eq 10 * $stdout.winsize[1] + 10
        expect(cursor.get_pointer_from_xy(20, 20)).
          to eq 20 * $stdout.winsize[1] + 20
      end
    end

    describe '#get_xy_from_pointer' do
      let(:cursor_width) { cursor.instance_variable_get(:@width) }

      it 'should properly calculate coordinates from buffer pointer' do
        expect(cursor.get_xy_from_pointer(0)).to eq [0, 0]
        expect(cursor.get_xy_from_pointer(1)).to eq [1, 0]
        expect(cursor.get_xy_from_pointer(10)).to eq [10, 0]
        expect(cursor.get_xy_from_pointer(200)).
          to eq [200 - (200 / cursor_width).floor * cursor_width,
                 (200 / cursor_width).floor]
      end
    end

    context 'move methods' do
      def current_coords
        [cursor.instance_variable_get(:@x), cursor.instance_variable_get(:@y)]
      end

      before do
        expect(current_coords).to eq [0, 0]
      end

      describe '#move_to' do
        it 'should properly set absolute position of cursor' do
          expect(cursor.move_to(5, 10)).to be_instance_of described_class
          expect(current_coords).to eq [5, 10]
        end
      end

      describe '#move_by' do
        it 'should properly move cursor right and down' do
          expect(cursor).to receive(:right).with(7)
          expect(cursor).to receive(:down).with(3)
          expect(cursor.move_by(7, 3)).to be_instance_of described_class
        end

        it 'should properly move cursor left and up' do
          expect(cursor).to receive(:left).with(2)
          expect(cursor).to receive(:up).with(4)
          expect(cursor.move_by(-2, -4)).to be_instance_of described_class
        end

        it 'should change current coordinates' do
          cursor.move_by(7, 3)
          expect(current_coords).to eq [7, 3]
          cursor.move_by(-1, -1)
          expect(current_coords).to eq [6, 2]
        end
      end

      describe '#up' do
        it 'should properly move cursor up with default arguments' do
          expect(cursor.up).to be_instance_of described_class
          expect(current_coords).to eq [0, -1]
        end

        it 'should properly move cursor up with argument' do
          expect(cursor.up(3)).to be_instance_of described_class
          expect(current_coords).to eq [0, -3]
        end
      end

      describe '#down' do
        it 'should properly move cursor down with default arguments' do
          expect(cursor.down).to be_instance_of described_class
          expect(current_coords).to eq [0, 1]
        end

        it 'should properly move cursor down with argument' do
          expect(cursor.down(5)).to be_instance_of described_class
          expect(current_coords).to eq [0, 5]
        end
      end

      describe '#left' do
        it 'should properly move cursor left with default arguments' do
          expect(cursor.left).to be_instance_of described_class
          expect(current_coords).to eq [-1, 0]
        end

        it 'should properly move cursor left with argument' do
          expect(cursor.left(4)).to be_instance_of described_class
          expect(current_coords).to eq [-4, 0]
        end
      end

      describe '#right' do
        it 'should properly move cursor right with default arguments' do
          expect(cursor.right).to be_instance_of described_class
          expect(current_coords).to eq [1, 0]
        end

        it 'should properly move cursor right with argument' do
          expect(cursor.right(5)).to be_instance_of described_class
          expect(current_coords).to eq [5, 0]
        end
      end
    end

    context 'erase methods' do
      let(:width) { $stdout.winsize[1] }
      let(:height) { $stdout.winsize[0] }

      describe '#erase' do
        def get_buffer_in_xy(x, y)
          pointer = cursor.get_pointer_from_xy(x, y)
          cursor.instance_variable_get(:@buffer)[pointer]
        end

        def build_char_in_xy(chr, x, y)
          cursor.class.wrap chr, { x: x, y: y }
        end

        it 'should properly erase the specified region' do
          (height - 1).times do |y|
            cursor.move_to 0, y
            (width - 1).times { cursor.write 'a' }
          end

          expect(cursor.erase(1, 1, 3, 2)).to be_instance_of described_class
          1.upto(2) do |y|
            1.upto(3) do |x|
              expect(get_buffer_in_xy(x, y)).to eq build_char_in_xy(' ', x, y)
            end
          end
          expect(get_buffer_in_xy(0, 1)).to eq build_char_in_xy('a', 0, 1)
        end
      end

      describe '#erase_to_end' do
        it 'should properly erase from current position to the end of line' do
          cursor.move_to 5, 6

          expect(cursor).to receive(:erase).with(5, 6, width - 1, 6)
          expect(cursor.erase_to_end).to be_instance_of described_class
        end
      end

      describe '#erase_to_start' do
        it 'should properly erase from current position to the start of line'do
          cursor.move_to 5, 6

          expect(cursor).to receive(:erase).with(0, 6, 5, 6)
          expect(cursor.erase_to_start).to be_instance_of described_class
        end
      end

      describe '#erase_to_down' do
        it 'should properly erase from current line to down' do
          cursor.move_to 5, 6

          expect(cursor)
            .to receive(:erase).with(0, 6, width - 1, height - 1)
          expect(cursor.erase_to_down).to be_instance_of described_class
        end
      end

      describe '#erase_to_up' do
        it 'should properly erase from current line to up' do
          cursor.move_to 5, 6

          expect(cursor).to receive(:erase).with(0, 0, width - 1, 6)
          expect(cursor.erase_to_up).to be_instance_of described_class
        end
      end

      describe '#erase_line' do
        it 'should properly erase the current line' do
          cursor.move_to 5, 6

          expect(cursor).to receive(:erase).with(0, 6, width - 1, 6)
          expect(cursor.erase_line).to be_instance_of described_class
        end
      end

      describe '#erase_screen' do
        it 'should properly erase the entire screen' do
          expect(cursor).to receive(:erase).with(0, 0, width - 1, height - 1)
          expect(cursor.erase_screen).to be_instance_of described_class
        end
      end
    end

    context 'styling methods' do
      let(:display) { cursor.instance_variable_get(:@display) }

      describe '#foreground' do
        it 'should properly set foreground color' do
          expect(cursor.foreground(:green)).to be_instance_of described_class
          expect(cursor.instance_variable_get(:@foreground)).to eq :green
        end
      end

      describe '#background' do
        it 'should properly set background color' do
          expect(cursor.background(:red)).to be_instance_of described_class
          expect(cursor.instance_variable_get(:@background)).to eq :red
        end
      end

      describe '#bold' do
        it 'should properly toggle bold mode' do
          expect(cursor.bold).to be_instance_of described_class
          expect(display[:bold]).to be_truthy

          cursor.bold false
          expect(display[:bold]).to be_falsey
        end
      end

      describe '#dim' do
        it 'should properly toggle dim mode' do
          expect(cursor.dim).to be_instance_of described_class
          expect(display[:dim]).to be_truthy

          cursor.dim false
          expect(display[:dim]).to be_falsey
        end
      end

      describe '#underlined' do
        it 'should properly toggle underlined mode' do
          expect(cursor.underlined).to be_instance_of described_class
          expect(display[:underlined]).to be_truthy

          cursor.underlined false
          expect(display[:underlined]).to be_falsey
        end
      end

      describe '#blink' do
        it 'should properly toggle blink mode' do
          expect(cursor.blink).to be_instance_of described_class
          expect(display[:blink]).to be_truthy

          cursor.blink false
          expect(display[:blink]).to be_falsey
        end
      end

      describe '#reverse' do
        it 'should properly toggle reverse mode' do
          expect(cursor.reverse).to be_instance_of described_class
          expect(display[:reverse]).to be_truthy

          cursor.reverse false
          expect(display[:reverse]).to be_falsey
        end
      end

      describe '#hidden' do
        it 'should properly toggle hidden mode' do
          expect(cursor.hidden).to be_instance_of described_class
          expect(display[:hidden]).to be_truthy

          cursor.hidden false
          expect(display[:hidden]).to be_falsey
        end
      end
    end

    describe '#hide_cursor' do
      it 'should hide cursor' do
        expect($stdout).to receive(:write).with("\e[?25l")
        expect(cursor.hide_cursor).to be_instance_of described_class
      end
    end

    describe '#show_cursor' do
      it 'should show cursor' do
        expect($stdout).to receive(:write).with("\e[?25h")
        expect(cursor.show_cursor).to be_instance_of described_class
      end
    end

    describe '#write_control' do
      it 'should encode string and write control sequence to TTY' do
        expect($stdout).to receive(:write).with("\ec")
        expect(cursor.write_control('c')).to be_nil
      end
    end

    describe '#reset_tty!' do
      it 'should properly reset TTY state and return self' do
        expect($stdout).to receive(:write).with("\ec")
        expect(cursor.reset_tty!).to eq cursor
      end
    end
  end
end
