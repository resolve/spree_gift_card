class AddDeletedAtToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :deleted_at, :datetime
    add_index :spree_gift_cards, :deleted_at
  end
end
