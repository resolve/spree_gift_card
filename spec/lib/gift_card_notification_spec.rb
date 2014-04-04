require "spec_helper"

describe GiftCardNotification do
  describe ".send_notifications!" do
    let! (:gift_card) { create(:gift_card, expiration_date: 7.days.from_now) }

    it "calls mailer for expiring gift_card" do
      mailer = double
      mailer.should_receive(:deliver)
      expect(Spree::GiftCardMailer).to receive(:gift_card_expiring).with(an_instance_of(Spree::GiftCard)).and_return(mailer)

      GiftCardNotification.send_notifications!(7)
    end
  end
end
