class AddExpirationDateToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :expiration_date, :datetime
  end
end
