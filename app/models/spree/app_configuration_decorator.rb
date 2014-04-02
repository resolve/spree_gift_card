Spree::AppConfiguration.class_eval do
  preference :gift_card_default_expiration_date_in_days, :datetime, default: 90
end
