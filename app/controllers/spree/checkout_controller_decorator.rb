Spree::CheckoutController.class_eval do
  include Spree::GiftCodes
  append_before_filter :add_gift_codes, only: :update

  private

  def add_gift_codes
    unless apply_gift_codes
      render :edit and return
    end
  end
end
