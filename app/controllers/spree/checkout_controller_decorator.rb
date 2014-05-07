Spree::CheckoutController.class_eval do

  Spree::PermittedAttributes.checkout_attributes << :gift_code

  append_before_filter :add_gift_codes, only: :update

  private

  def add_gift_codes
    if object_params[:gift_code]
      @order.gift_code = object_params[:gift_code]
      unless apply_gift_codes
        flash[:error] = Spree.t(:gc_apply_failure)
        render :edit
        return
      end
    end
  end
end
