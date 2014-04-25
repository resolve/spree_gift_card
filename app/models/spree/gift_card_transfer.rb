class Spree::GiftCardTransfer < ActiveRecord::Base
  belongs_to :source
  belongs_to :destination

  validates_presence_of :source, :destination
end
