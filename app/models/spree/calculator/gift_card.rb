require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    class GiftCard < Calculator

      def self.description
        Spree.t(:gift_card_calculator)
      end

      def compute(order, gift_card)
        order_adjustments = order.adjustments.where("amount < 0")
        order_adjustments.delete_if {|adj| adj.source == gift_card }
        credits = order_adjustments.map(&:amount).sum
        order_total = order.item_total + order.ship_total + order.additional_tax_total + credits
        [order_total, gift_card.current_value].min * -1
      end
    end
  end
end
