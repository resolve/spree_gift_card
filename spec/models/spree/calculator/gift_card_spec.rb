require 'spec_helper'

describe Spree::Calculator::GiftCard do
  it '.description' do
    Spree::Calculator::GiftCard.description.should eql('Gift Card Calculator')
  end

  describe '#compute' do
    let(:order) { create :order_ready_to_ship}
    let(:applied_gc) { create :gift_card, current_value: 110 }

    let(:gc) { create :gift_card, current_value: 80 }

    before do
      applied_gc.apply(order)
    end

    subject { gc.calculator }

    it "only redeems $40 from the second gc as the order total is 150." do
      expect(subject.compute(order, gc).to_f).to eql(-40.0)
    end
  end
end
