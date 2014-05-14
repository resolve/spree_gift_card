class RemoveSpreeGiftCardTransactions < ActiveRecord::Migration
  def change
    drop_table :spree_gift_card_transactions
  end
end
