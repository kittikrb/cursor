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
        expect(KittikRb::Cursor::Cursor.encode_to_vt100('c')).to eq "\ec"
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
        display: KittikRb::Cursor::Cursor::DISPLAY_CONFIG,
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
