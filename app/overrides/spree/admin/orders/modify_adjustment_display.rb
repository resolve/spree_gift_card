Deface::Override.new(
  virtual_path: 'spree/admin/orders/_form',
  name: "partialize_adjustment_table",
  replace_contents: "erb[silent]:contains('if order.adjustments.eligible.exists?')",
  closing_selector: "erb[silent]:contains('end')",
  partial: "spree/admin/orders/adjustment_table"
)
