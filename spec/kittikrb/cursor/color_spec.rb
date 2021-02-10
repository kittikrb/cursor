require "spec_helper"

describe KittikRb::Cursor::Color::Color do
  def expect_color(color, r, g, b)
    expect(color).to have_attributes(r: r, g: g, b: b)
  end

  def expect_black_color
    color = described_class.new(:black)

    expect_color(color, 0, 0, 0)
  end

  def expect_green_color
    color = described_class.new(:green)

    expect_color(color, 28, 172, 120)
  end

  def expect_channel(channel, given_color, expected_color)
    color = described_class.new(:black)

    expect(color.public_send(channel)).to eq(0)
    expect(color.public_send(channel, given_color))
      .to be_instance_of described_class
    expect(color.public_send(channel)).to eq(expected_color)
  end

  shared_examples "a color channel" do |channel|
    context "when provided with integer color value" do
      it "sets #{channel.upcase} channel to the value" do
        expect_channel(channel, 10, 10)
      end
    end

    context "when provided with string color value" do
      it "sets #{channel.upcase} channel to the value" do
        expect_channel(channel, "10", 10)
      end
    end

    context "when provided with out of bounds color value" do
      it "bounds #{channel.upcase} channel to the closest boundary" do
        expect_channel(channel, -500, 0)
      end

      it "bounds #{channel.upcase} channel to the closest boundary" do
        expect_channel(channel, 500, 255)
      end
    end
  end

  describe "::named?" do
    context "given a color name" do
      it "checks whether this color name is known" do
        expect(described_class.named?(:black)).to be true
        expect(described_class.named?(:BlaCk)).to be true
        expect(described_class.named?(:false_color)).to be false
      end
    end
  end

  describe "::hex?" do
    context "given a color value" do
      it "checks whether this color value is a valid HEX color" do
        expect(described_class.hex?("#001020")).to be true
        expect(described_class.hex?("#AABBCC")).to be true
        expect(described_class.hex?("#aaBBdD")).to be true
        expect(described_class.hex?("#INVALID")).to be false
      end
    end
  end

  describe "::rgb?" do
    context "given a color value" do
      it "checks whether this color value is a valid RGB color" do
        expect(described_class.rgb?("rgb(0, 10, 20)")).to be true
        expect(described_class.rgb?("rGb(0, 10, 50)")).to be true
        expect(described_class.rgb?("rgb(3000, 3000, 3000)")).to be false
      end
    end
  end

  describe "#new" do
    context "when provided with named color value" do
      it "creates color" do
        expect_black_color
      end

      it "creates color" do
        expect_green_color
      end
    end

    context "when provided with string named color value" do
      it "creates color" do
        expect_green_color
      end
    end

    context "when provided with RGB color map" do
      it "creates color" do
        color = described_class.new({r: 0, g: 16, b: 32})

        expect_color(color, 0, 16, 32)
      end
    end

    context "when provided with HEX color value" do
      it "creates color" do
        color = described_class.new("#001020")

        expect(color).to be_instance_of described_class

        expect_color(color, 0, 16, 32)
      end
    end

    context "when provided with RGB color value" do
      it "creates color" do
        color = described_class.new("rgb(0, 16, 32)")

        expect(color).to be_instance_of described_class

        expect_color(color, 0, 16, 32)
      end

      it "bounds color values to the closest boundary" do
        color = described_class.new("rgb(300, 300, 300)")

        expect(color).to be_instance_of described_class

        expect_color(color, 255, 255, 255)
      end
    end

    context "when provided with an invalid color value" do
      it "throws an exception" do
        expect { described_class.new("rgb(,,)") }
          .to raise_error(ColorError, "Color 'rgb(,,)' can't be parsed")
        expect { described_class.new("#WRONGC") }
          .to raise_error(ColorError, "Color '#WRONGC' can't be parsed")
        expect { described_class.new("wr0ng") }
          .to raise_error(ColorError, "Color 'wr0ng' can't be parsed")
        expect { described_class.new({r: nil, g: nil, b: nil}) }
          .to raise_error(ColorError, "Color '{:r=>nil, :g=>nil, :b=>nil}' can't be parsed")
      end
    end
  end

  describe "#r" do
    it_behaves_like "a color channel", :r
  end

  describe "#g" do
    it_behaves_like "a color channel", :g
  end

  describe "#b" do
    it_behaves_like "a color channel", :b
  end

  describe "#to_rgb" do
    context "for a color object" do
      it "returns its RGB representation" do
        color = described_class.new(:black)

        expect(color.to_rgb).to eq({r: 0, g: 0, b: 0})
        expect(color.r(10)).to be_instance_of described_class
        expect(color.g(20)).to be_instance_of described_class
        expect(color.b(30)).to be_instance_of described_class
        expect(color.to_rgb).to eq({r: 10, g: 20, b: 30})
      end
    end
  end

  describe "#to_hex" do
    context "for a color object" do
      it "returns its HEX representation" do
        color = described_class.new(:black)

        expect(color.to_hex).to eq("#000000")
        expect(color.r(16)).to be_instance_of described_class
        expect(color.g(32)).to be_instance_of described_class
        expect(color.b(48)).to be_instance_of described_class
        expect(color.to_hex).to eq("#102030")
      end
    end
  end
end
