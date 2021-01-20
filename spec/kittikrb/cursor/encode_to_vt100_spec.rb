require "spec_helper"

describe KittikRb::Cursor::VT100 do
  include described_class

  context "when provided with control code" do
    it "returns escape sequence" do
      expect(encode_to_vt100(1)).to eq("\e1")
    end
  end
end
