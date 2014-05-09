require 'spec_helper'

feature "viewing admin orders", js: true do
  given!(:order) { create :order_ready_to_ship }
  given!(:gc)    { create :gift_card }

  stub_authorization!

  background do
    gc.apply(order)
    order.reload
  end

  context "with deleted gift cards" do
    background do
      gc.destroy
    end

    scenario "still displays the gift card" do
      visit spree.edit_admin_order_path(order.to_param)
      expect(current_path).to eql(spree.edit_admin_order_path(order.to_param))

      within(".deleted-gc") do
        expect(page).to have_content(Spree::GiftCard.with_deleted.last.code)
      end
    end
  end

  context "with undeleted gift cards" do
    scenario "displays the gift card" do
      visit spree.edit_admin_order_path(order.to_param)
      expect(current_path).to eql(spree.edit_admin_order_path(order.to_param))

      within(".gc-code") { expect(page).to have_content(gc.code) }
      within(".gc-original-balance") { expect(page).to have_content(gc.original_value) }
      within(".gc-current-balance") { expect(page).to have_content(gc.current_value) }
      within(".gc-total") { expect(page).to have_content(Spree::Adjustment.where(source: gc).first.display_amount) }

    end
  end
end
