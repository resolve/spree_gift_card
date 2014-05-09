Spree::Admin::AdjustmentsController.class_eval do
  def refund_gc
    Spree::GiftCard.transaction do
      @order.adjustments.create!(order: @order, label: "Gift Card Refund", amount: -@adjustment.amount)
      gc = Spree::GiftCard.create!(
        name: Spree.t(:gift_card_return_name),
        note: Spree.t(:gift_card_return_note, order_number: @order.number),
        current_value: -@adjustment.amount,
        original_value: -@adjustment.amount,
        email: @order.user.email,
        user: @order.user
      )
      Spree::GiftCardMailer.gc_refund_email(gc, @order).deliver
    end

    redirect_to :back, notice: "Gift Card Refund Issued"
  end
end
