require 'spec_helper'

describe Spree::Calculator::GiftCard do
  it '.description' do
    Spree::Calculator::GiftCard.description.should eql('Gift Card Calculator')
  end

  describe '#compute' do
    # Order total: 150
    let(:order) { create :order_ready_to_ship}

    subject { gc.calculator.compute(order, gc).to_f }

    context "when there are no adjustments on the order" do
      context "with a gift card greater than the order total" do
        let(:gc) { create :gift_card, current_value: 160 }

        it "only applies the gift card to the maximum value of the order" do
          expect(subject).to eql(-150.0)
        end
      end

      context "with a gift card less than or equal to the order total" do
        let(:gc) { create :gift_card, current_value: 140 }

        it "only applies the gift card to the maximum value of the card" do
          expect(subject).to eql(-140.0)
        end
      end
    end

    context "when there is another adjustment on the order" do
      let(:applied_gc) { create :gift_card, current_value: 130 }
      let(:gc) { create :gift_card, current_value: 50 }

      before do
        applied_gc.apply(order)
        order.update_totals
      end


      it "only redeems $20 of the gift card" do
        expect(subject).to eql(-20.0)
      end
    end

    context "when updating the order after it has changed totals" do
      let(:gc) { create :gift_card, current_value: 180 }

      it "increases its value applied if the orders total is increased", focus: true do
        order.adjustments.create!(label: "increase", amount: 20)
        order.update_totals
        expect(subject).to eql(-170.0)
      end

      it "decreases its value applied if the orders total is decreased" do
        order.adjustments.create!(label: "increase", amount: -50)
        order.update_totals
        expect(subject).to eql(-100.0)
      end
    end
  end
end
