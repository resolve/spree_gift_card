require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    class GiftCard < Calculator

      def self.description
        Spree.t(:gift_card_calculator)
      end

      def compute(order, gift_card)
        credits = order.
          adjustments.
          where("amount < 0").
          where.not("originator_type = 'Spree::GiftCard' AND originator_id = ?", gift_card.id).
          map(&:amount).sum

        order_total = order.item_total + order.ship_total + order.tax_total + credits
        [order_total, gift_card.current_value].min * -1
      end

    end
  end
end
