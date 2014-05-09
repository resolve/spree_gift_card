Spree::LineItem.class_eval do
  has_one :gift_card, dependent: :destroy

  validates :gift_card, presence: { if: Proc.new{ |item| item.product.is_gift_card? } }
  validates :quantity,  numericality: { if: Proc.new{ |item| item.product.is_gift_card? }, less_than_or_equal_to: 1 }

  def associate_gift_card
    Spree::OrderMailer.gift_card_email(gift_card, self.order).deliver

    if user = Spree::User.find_by(email: gift_card.email)
      gift_card.associate_user!(user)
    end
  end
end
