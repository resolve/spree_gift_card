require 'spec_helper'

describe Spree::Admin::AdjustmentsController do
  describe "POST refund_gc" do
    stub_authorization!

    let(:order) { create :order_ready_to_ship }
    let(:gc) do
      Spree::GiftCard.create!(
        name: "test",
        email: 't@t.t',
        current_value: 10,
        original_value: 10
      )
    end
    let(:adjustment) { order.adjustments.gift_card.first }
    let(:request_params) do
      {
        use_route: :spree,
        id: adjustment.to_param,
        order_id: order.to_param
      }
    end

    subject { post :refund_gc, request_params }

    before do
      @request.env["HTTP_REFERER"] = spree.root_path
      gc.apply(order)
    end

    it "creates an adjustment the opposite value of the gift card adjustment" do
      subject
      expect(order.reload.adjustments.last.amount).to eql(adjustment.amount * -1)
    end

    describe "the created gift card" do
      it "has the opposite value of the adjustment" do
        subject
        expect(order.user.reload.gift_cards.first.current_value).to eql(adjustment.amount * -1)
      end
    end
  end
end
