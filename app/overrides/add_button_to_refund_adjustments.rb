Deface::Override.new(
  virtual_path: "spree/admin/adjustments/_adjustments_table",
  name: "add_button_to_refund_adjustments",
  insert_bottom: "td.actions",
  partial: "spree/admin/adjustments/remove_gc_button"
)
