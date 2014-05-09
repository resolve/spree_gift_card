Spree::Adjustment.class_eval do
  scope :gift_card, -> { where(source_type: "Spree::GiftCard") }
  scope :non_gift_card, ->{ where.not(source_type: "Spree::GiftCard") }
end
