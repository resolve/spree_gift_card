require 'spec_helper'

describe Spree::Calculator::GiftCard do
  it '.description' do
    Spree::Calculator::GiftCard.description.should eql('Gift Card Calculator')
  end

  describe '#compute' do
    let(:order) { create :order_ready_to_ship}
    let(:applied_gc) do
      Spree::GiftCard.create!(
        name: "test",
        email: "t@t.t",
        current_value: 10,
        original_value: 10
      )
    end

    let(:gc) do
      Spree::GiftCard.create!(
        name: "test",
        email: "t@t.t",
        current_value: 50,
        original_value: 50
      )
    end

    before do
      applied_gc.apply(order)
    end

    subject { gc.calculator }

    it "only redeems $40 from the second gc as the order total is 50." do
      expect(subject.compute(order, gc).to_f).to eql(-40.0)
    end
  end
end
