class AddIndexToGiftCodeOnSpreeGiftCards < ActiveRecord::Migration
  def change
    add_index :spree_gift_cards, :code
  end
end
