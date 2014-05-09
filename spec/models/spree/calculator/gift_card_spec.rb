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
        current_value: 130,
        original_value: 130
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

    it "only redeems $20 from the second gc as the order total is 150." do
      expect(subject.compute(order, gc).to_f).to eql(-20.0)
    end
  end
end
