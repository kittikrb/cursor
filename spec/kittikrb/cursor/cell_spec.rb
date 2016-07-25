require 'spec_helper'

describe KittikRb::Cursor::Cell do
    subject(:cell) { described_class.new }

    let!(:default_values) do
      {
        char: ' ',
        x: 0, y: 0,
        background: false, foreground: false,
        display: described_class::DISPLAY_CONFIG
      }
    end

    let(:custom_values) do
      {
        x: 20, y: 10,
        background: :white, foreground: :black,
        display: {
          bold: true,
          dim: true,
          underlined: true,
          blink: true,
          reverse: true,
          hidden: true
        }
      }
    end

    describe '#new' do
      context 'when no arguments passed' do
        it 'should be initialized with default values' do
          default_values.each do |key, value|
            expect(cell.instance_variable_get("@#{key}")).to eq(value)
          end
        end
      end

      context 'when custom arguments passed' do
        subject(:cell) { described_class.new(' ', custom_values) }

        it 'should be initialized with custom values' do
          expect(cell.char).to eq ' '
          custom_values.each do |key, value|
            expect(cell.instance_variable_get("@#{key}")).to eq value
          end
        end
      end
    end

    describe '#char' do
      subject { cell.char }

      context 'when set to char' do
        before { subject = 't' }

        it { is_expected.to eq 't' }
      end

      context 'when set to string' do
        before { subject = 'text' }

        it { is_expected.to eq 't' }
      end
    end

    describe '#x' do
      subject { cell.x }

      context 'when set to integer number' do
        before { subject = 40 }

        it { is_expected.to eq 40 }
      end

      context 'when set to float number' do
        before { subject = 40.5 }

        it { is_expected.to eq 40 }
      end
    end

    describe '#y' do
      subject { cell.y }

      context 'when set to integer number' do
        before { subject = 40 }

        it { is_expected.to eq 40 }
      end

      context 'when set tp float number' do
        before { subject = 40.5 }

        it { is_expected.to eq 40 }
      end
    end

    describe '#background' do
      subject { cell.background }

      context 'when set with color name' do
        before { subject = :black }

        it { is_expected.to eq :black }
      end
    end

    describe '#foreground' do
      subject { cell.foreground }

      context 'when set with color name' do
        before { subject = :black }

        it { is_expected.to eq :black }
      end
    end

    describe '#display' do
      subject { cell.display }

      context 'when set to default values' do
        it { is_expected.to all be_false }
      end

      context 'when set to custom values' do
        let(:custom_display) { custom_values.display }

        before { subject = custom_display }


      end
    end

    describe '#modified' do
      subject { cell.modified }

      context 'when cell marked as not modified' do
        it { is_expected.to all be_false }
      end

      context 'when cell marked as modified' do
        before { subject = true }

        it { is_expected.to be_true }
      end
    end

    describe '#reset!' do
      subject(:cell) { described_class.new() }

      before do
        cell.reset!
      end

      it 'should reset the cell contents and display settings' do
        default_values.each do |key, value|
          expect(cell.instance_variable_get("@#{key}")).to eq value
        end
      end
    end

    describe '#to_s' do
      subject { cell.to_s }

      context 'when cell has default values' do
        it 'should convert cell into ASCII control sequence' do
          expect(subject).to eq '\u001b[1;1f \u001b[0m'
        end
      end

      context 'when cell has custom values' do
        subject { described_class.new(' ', custom_values).to_s }

        it 'should convert cell into ASCII control sequence' do
          expect(subject).to eq '\u001b[11;21f\u001b[48;5;0m\u001b[38;5;15m'\
                                '\u001b[1m\u001b[2m\u001b[4m\u001b[5m'\
                                '\u001b[7m\u001b[8m \u001b[0m'
        end
      end
    end
end
