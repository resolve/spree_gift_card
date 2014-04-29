require 'spec_helper'

describe Spree::Order do

  let(:gift_card) { create(:gift_card, variant: create(:variant, price: 25, product: create(:product, is_gift_card: true))) }

  context '#finalize!' do

    context 'when redeeming gift card' do
      it 'debits gift cards current value' do
        gift_card.current_value.should eql(25.0)
        order = create(:order_with_totals)
        order.line_items = [create(:line_item, order: order, price: 75, variant: create(:variant, price: 75))]
        order.reload # reload so line item is associated
        order.update!
        gift_card.apply(order)
        gift_card.reload.current_value.to_f.should eql(25.0)
        order.finalize!
        gift_card.reload.current_value.to_f.should eql(0.0)
      end
    end

    context "with other credits" do
      it "does not let the order total fall below zero" do
        order = create(:order_with_totals)
        order.line_items = [create(:line_item, order: order, price: 40, variant: create(:variant, price: 40))]
        order.adjustments.create(:label => I18n.t(:store_credit) , :amount => -25)
        order.reload
        order.update!
        gift_card.apply(order)
        order.total.to_f.should eql(0.0)
      end
    end

  end

  describe "#applied_gift_cards" do
    context "with two adjustments, one a gift card and one normal" do
      let(:order) { create :order }
      let(:gc) { create :gift_card }

      before do
        gc.apply(order)
        order.adjustments.create!(label: "test", amount: -5)

        order.reload
      end

      subject { order.applied_gift_cards }

      it "returns the gift cards for adjustments that have them" do
        expect(subject.to_a).to eql([gc])
      end
    end
  end
end
