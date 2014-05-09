Deface::Override.new(
  virtual_path: 'spree/admin/orders/_form',
  name: "exclude_gc_adjustments_from_order_adjustments",
  replace: "erb[loud]:contains(':adjustments => @order.adjustments')",
  partial: "spree/admin/orders/adjustment_table"
)
