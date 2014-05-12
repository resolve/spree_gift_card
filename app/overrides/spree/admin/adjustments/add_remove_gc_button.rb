Deface::Override.new(
  virtual_path: "spree/admin/adjustments/_adjustment",
  name: "add_remove_gc_button",
  replace_contents: "td.actions",
  partial: "spree/admin/adjustments/adjustment_actions"
)
