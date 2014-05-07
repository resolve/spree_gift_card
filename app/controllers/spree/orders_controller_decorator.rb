Spree::OrdersController.class_eval do
  durably_decorate :after_update_attributes, mode: 'soft', sha: 'bdc8fc02ee53912eda684bdd37a6266594665866' do
    @order.gift_code = Array.wrap(params[:gift_code]).first
    apply_gift_codes
    original_after_update_attributes
  end
end
