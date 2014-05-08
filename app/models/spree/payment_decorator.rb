Spree::Payment.class_eval do
  self.state_machine.after_transition to: :completed, do: :associate_gift_cards

  def associate_gift_cards
    order.line_items.each do |li|
      li.associate_gift_card if li.gift_card
    end
  end
end
