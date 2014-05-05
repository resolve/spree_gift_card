require 'spec_helper'

describe Spree::Payment do
  describe "transitioning from any state to completed" do
    let!(:payment) { create :payment }

    subject { payment.complete }

    it "calls 'associate_gift_cards after the transition" do
      expect(payment).to receive(:associate_gift_cards).once
      subject
    end
  end

  describe "#associate_gift_cards" do
    let!(:order) { create :order }
    let!(:product) { create :product, is_gift_card: true }
    let!(:line_item) { create :line_item, order: order, product: product, gift_card: gc }
    let!(:gc) { create :gift_card }

    before do
      order.update!
    end

    it "calls associate_gift_card on eligible line items on payment completion" do
      expect_any_instance_of(Spree::LineItem).to receive(:associate_gift_card).once
      order.payments.create(amount: order.total).complete
    end
  end
end
