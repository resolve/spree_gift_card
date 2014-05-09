Spree::OrdersController.class_eval do
  include Spree::GiftCodes

  before_filter :add_gift_codes, only: :update

  protected

  def add_gift_codes
    unless apply_gift_codes(current_order)
      # We set the order because the edit template expects it to be set.
      @order = current_order
      render :edit and return
    end
  end
end
