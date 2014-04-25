class CreateSpreeGiftCardTransfers < ActiveRecord::Migration
  def change
    create_table :spree_gift_card_transfers do |t|
      t.references :source, index: true, null: false
      t.references :destination, index: true, null: false

      t.timestamps
    end
  end
end
