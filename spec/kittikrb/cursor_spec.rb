require 'spec_helper'

describe KittikRb::Cursor do
  it 'has a version number' do
    expect(KittikRb::Cursor::VERSION).not_to be nil
  end

  describe '#create' do
    it 'should return a new instance of KittikRb::Cursor::Cursor' do
      expect(KittikRb::Cursor.create).
        to be_instance_of KittikRb::Cursor::Cursor
    end
  end

  describe KittikRb::Cursor::Cursor do
    let!(:cursor) { KittikRb::Cursor::Cursor.new }

    describe '#self.encode_to_vt100' do
      it 'should return escaped string' do
        expect(described_class.encode_to_vt100('c')).to eq "\ec"
      end
    end

    describe '#self.wrap' do
      let(:x) { 0 }
      let(:y) { 0 }
      let(:display) { {bold: true, underlined: true} }

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

    describe '#move_to' do
      def current_coords
        [cursor.instance_variable_get(:@x), cursor.instance_variable_get(:@y)]
      end

      it 'should properly set absolute position of cursor' do
        expect(current_coords).to eq [0, 0]
        expect(cursor.move_to(5, 10)).to be_instance_of described_class
        expect(current_coords).to eq [5, 10]
      end
    end

    describe '#up' do
      it 'should properly set absolute position of cursor' do
        expect(cursor.up).to be_instance_of described_class
      end
      it 'should properly set absolute position of cursor position' do
        expect(cursor.up(5)).to be_instance_of described_class
      end
    end

    describe '#down' do
      it 'should properly set absolute position of cursor' do
        expect(cursor.down).to be_instance_of described_class
      end
      it 'should properly set absolute position of cursor position' do
        expect(cursor.down(5)).to be_instance_of described_class
      end
    end

    describe '#left' do
      it 'should properly set absolute position of cursor' do
        expect(cursor.left).to be_instance_of described_class
      end
      it 'should properly set absolute position of cursor position' do
        expect(cursor.left(5)).to be_instance_of described_class
      end
    end

    describe '#right' do
      it 'should properly set absolute position of cursor' do
        expect(cursor.right).to be_instance_of described_class
      end
      it 'should properly set absolute position of cursor position' do
        expect(cursor.right(5)).to be_instance_of described_class
      end
    end

    describe '#move_by' do
      def current_coords
        [cursor.instance_variable_get(:@x), cursor.instance_variable_get(:@y)]
      end

      it 'should properly set absolute position of cursor' do
        expect(current_coords).to eq [0, 0]
        expect(cursor.move_by(3, -7)).to be_instance_of described_class
        expect(current_coords).to eq [3, -7]
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
