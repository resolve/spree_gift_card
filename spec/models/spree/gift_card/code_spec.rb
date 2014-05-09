require 'spec_helper'

describe Spree::GiftCard::Code do
  describe "#code" do
    let(:gc) { build :gift_card }
    subject { described_class.generate(gc) }

    before do
      allow(Kernel).to receive(:rand).and_return(0.5)
      allow(Time).to receive(:now).and_return(Time.at(1399587888))
    end

    it "returns a forty character sha of Time.now and rand" do
      expect(subject).to eql("be7fe3c3f029b195607d4c42e35c65fb6c26c90e")
    end
  end
end
