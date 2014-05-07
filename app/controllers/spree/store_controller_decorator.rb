Spree::StoreController.class_eval do
  protected

  def apply_gift_codes
    success_state = true

    Array.wrap(params[:gift_code]).reject(&:blank?).each do |code|
      card = Spree::GiftCard.find_by(code: code)

      unless card
        success_state = false
        next
      end

      if card.order_activatable?(@order) && card.apply(@order)
        fire_event('spree.checkout.gift_code_added', :gift_code => card.code)
      else
        success_state = false
      end
    end

    success_state ?
      flash[:notice] = Spree.t(:gift_code_applied) :
      flash[:error] = Spree.t(:gift_code_not_found)

    success_state
  end
end
