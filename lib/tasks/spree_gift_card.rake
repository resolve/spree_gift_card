require "gift_card_notification"

namespace :spree_gift_card do
  desc "Send a expiring soon email to emails of all gift cards soon to expire"
  task send_expiration_notifications: :environment do
    GiftCardNotification.send_notifications!(7)
  end
end
