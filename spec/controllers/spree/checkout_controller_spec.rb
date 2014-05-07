require 'spec_helper'

describe Spree::CheckoutController do
  let(:user) { create :user }
  let(:order) { create :order_with_totals, user: user }
  let(:valid_params) {{ use_route: spree, id: order.to_param, state: "address" }}

  before do
    allow(controller).to receive(:try_current_spree_user).and_return(user)
    allow(controller).to receive(:current_spree_user).and_return(user)
    allow(controller).to receive(:authorize!).and_return(true)
  end

  describe "PUT update" do
    subject { put :update, valid_params }
    before do
      session[:order_id] = order.id
    end

    context "adding a single gift code" do
      let(:gc) { create :gift_card }
      let(:first_adjustment) { order.adjustments.gift_card.first }

      before do
        valid_params.merge!(gift_code: gc.code)
      end

      context "when the gift code is not already applied" do
        it "applies the gift code" do
          subject
          order.reload
          expect(first_adjustment.originator).to eql(gc)
        end

        describe "the response" do
          it "is successful" do
            subject
            expect(response).to be_success
          end
        end
      end

      context "when the gift card is applied" do
        before do
          gc.apply(order)
        end

        it "doesn't reapply the gift card" do
          expect(order.adjustments.gift_card).to have(1).items
        end

        describe "the response" do
          it "renders the edit template" do
            subject
            expect(response).to render_template(:edit)
          end

          it "sets the error flash" do
            subject
            expect(flash[:error]).to eql(Spree.t(:gc_apply_failure))
          end
        end
      end
    end

    context "adding multiple gift codes" do
      let(:gcs) { create_list :gift_card, 2 }

      before do
        valid_params.merge!(gift_code: gcs.map(&:code))
      end

      it "creates the relevant adjustments for all three gift codes applied" do
        subject
        expect(order.adjustments.gift_card.map(&:originator_id)).to eql(gcs.map(&:id))
      end

      describe "the response" do
        it "doesnt set the error flash" do
          subject
          expect(flash[:error]).to_not be
        end

        it "responds correctly" do
          subject
          expect(response).to be_success
        end
      end
    end
  end
end
