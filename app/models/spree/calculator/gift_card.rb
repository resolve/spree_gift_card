require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    class GiftCard < Calculator

      def self.description
        Spree.t(:gift_card_calculator)
      end

      def compute(order, gift_card)
        # order_total is item_total + shipment_total + adjustment_total
        # at any time this calculator is called, item_total and shipment_total won't change
        # so we only need to recaclulate adjustment_total for up to date information.
        order_adjustments = order.adjustments.eligible.to_a
        order_adjustments.delete_if { |adj| adj.source == gift_card }

        adj_total = order.line_items.sum(:adjustment_total) +
          order.shipments.sum(:adjustment_total) +
          order_adjustments.map(&:amount).sum
        order_total = order.item_total + order.ship_total + adj_total
        [order_total, gift_card.current_value].min * -1
      end
    end
  end
end
