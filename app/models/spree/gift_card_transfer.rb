class Spree::GiftCardTransfer < ActiveRecord::Base
  belongs_to :source, class_name: "Spree::GiftCard"
  belongs_to :destination, class_name: "Spree::GiftCard"

  validates_presence_of :source, :destination
end
