Spree::Adjustment.class_eval do
  scope :gift_card, -> { where(:originator_type => 'Spree::GiftCard') }
  scope :non_gift_card, ->{ where.not(originator_type: "Spree::GiftCard") }
end
