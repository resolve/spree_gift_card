Spree::OrderMailer.class_eval do
  def gift_card_email(card, order)
    @gift_card, @order = card, order
    subject = "#{Spree::Config[:site_name]} Gift Card"
    @gift_card.update_attribute(:sent_at, Time.now)
    mail(:to => @gift_card.email, :from => from_address, :subject => subject)
  end
end
