class GiftCardNotification
  def self.send_notifications! expires_in_days
    Spree::GiftCard.expires_in(expires_in_days).each do |gc|
      Spree::GiftCardMailer.gift_card_expiring(gc).deliver
    end
  end
end
