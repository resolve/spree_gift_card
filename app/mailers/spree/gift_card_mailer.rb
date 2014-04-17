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

  def gc_refund_email(gift_card, order)
    @gift_card = gift_card
    @order = order
    subject = Spree.t(:gift_card_returned_subject)
    mail(to: @gift_card.email, from: from_address, subject: subject)
  end
end
