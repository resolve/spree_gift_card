require "gift_card_notification"

namespace :spree_gift_card do
  desc "Send a expiring soon email to emails of all gift cards soon to expire"
  task :send_expiration_notifications, [:expires_in_days] => :environment do |t, args|
    args.with_defaults(expires_in_days: 7 )
    GiftCardNotification.send_notifications!(args[:expires_in_days].to_i)
  end
end
