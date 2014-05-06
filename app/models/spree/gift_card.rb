require 'spree/core/validators/email'

module Spree
  class GiftCard < ActiveRecord::Base
    class ExpiredGiftCardException < StandardError; end;
    class InvalidUserException < StandardError; end;

    acts_as_paranoid

    include Spree::Core::CalculatedAdjustments

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

    belongs_to :user, class_name: Spree.user_class.to_s
    belongs_to :variant
    belongs_to :line_item

    has_many :gift_card_transfers, class_name: "Spree::GiftCardTransfer", foreign_key: "source_id"
    has_many :transactions, class_name: 'Spree::GiftCardTransaction'
    has_many :transferred_gift_cards, through: :gift_card_transfers, source: :destination
    has_one :origin, class_name: "Spree::GiftCardTransfer", foreign_key: "destination_id"
    has_one :calculator, class_name: "Spree::Calculator::GiftCard", as: :calculable

    validates :code,               presence: true, uniqueness: true
    validates :current_value,      presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :email, email: true, presence: true
    validates :name,               presence: true
    validates :original_value,     presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :expiration_date,    presence: true

    before_validation :generate_code, on: :create
    before_validation :initialize_calculator, on: :create
    before_validation :set_values, on: :create
    before_validation :set_expiration_date

    scope :expires_in, ->(days) { where("expiration_date >= ? and expiration_date <= ?",
      days.days.from_now.beginning_of_day, days.days.from_now.end_of_day) }

    scope :active, ->(){ where('current_value != 0.0 AND expiration_date > ?', DateTime.current) }


    def self.default_expiration_date
      Spree::Config.gc_default_expiration_days.days.from_now
    end

    def self.sortable_attributes
      [
        ["Creation Date", "created_at"],
        ["Expiration Date", "expiration_date"],
        ["Redemption Code", "code"],
        ["Current Balance", "current_value"],
        ["Original Balance", "original_value"],
        ["Note", "note"]
      ]
    end

    def apply(order)
      # Nothing to do if the gift card is already associated with the order
      return if order.gift_credit_exists?(self)
      raise ExpiredGiftCardException.new if expired?
      raise InvalidUserException.new if !is_valid_user?(order.user)

      associate_user!(order.user)

      create_adjustment(Spree::GiftCard.model_name.human.titlecase, order, order, true)
      order.update!
    end

    def expired?
      DateTime.current > expiration_date
    end

    # Calculate the amount to be used when creating an adjustment
    def compute_amount(calculable)
      self.calculator.compute(calculable, self)
    end

    def debit(amount, order)
      raise 'Cannot debit gift card by amount greater than current value.' if (self.current_value - amount.to_f.abs) < 0
      transaction = self.transactions.build
      transaction.amount = amount
      transaction.order  = order
      self.current_value = self.current_value - amount.abs
      self.save
    end

    def price
      if self.line_item
        return self.line_item.price * self.line_item.quantity
      elsif self.variant
        return self.variant.price
      else
        return self.current_value
      end
    end

    def order_activatable?(order)
      order &&
      !expired? &&
      current_value > 0 &&
      !UNACTIVATABLE_ORDER_STATES.include?(order.state) &&
      is_valid_user?(order.user)
    end

    def status
      if self.current_value <= 0
        :redeemed
      elsif self.expired?
        :expired
      else
        :active
      end
    end

    private

    def set_expiration_date
      if self.expiration_date.blank?
        self.expiration_date = Spree::GiftCard.default_expiration_date
      end
    end

    def is_valid_user?(user)
      !self.user || (self.user == user)
    end

    def associate_user!(user)
      self.user = user
      self.save!
    end

    def generate_code
      until self.code.present? && self.class.where(code: self.code).count == 0
        self.code = Digest::SHA1.hexdigest([Time.now, rand].join)
      end
    end

    def initialize_calculator
      self.calculator = Spree::Calculator::GiftCard.new
    end

    def set_values
      if self.variant
        self.current_value  = self.variant.try(:price)
        self.original_value = self.variant.try(:price)
      end
    end
  end
end
