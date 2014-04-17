class Spree::GiftCardMailer < Spree::BaseMailer

  def gift_card_transferred gift_card, sender
    @gift_card = gift_card
    @sender = sender
    mail(to: gift_card.email,
         from: from_address,
         subject: Spree.t(:subject, scope: [:gift_card_mailer, :gift_card_transferred]))
  end

  def gift_card_issued gift_card
    @gift_card = gift_card
    mail(to: gift_card.email,
         from: from_address,
         subject: Spree.t(:subject, scope: [:gift_card_mailer, :gift_card_issued]))
  end

  def gift_card_expiring gift_card
    @gift_card = gift_card
    mail(to: gift_card.email,
         from: from_address,
         subject: Spree.t(:subject, scope: [:gift_card_mailer, :gift_card_expiring]))
  end
end
