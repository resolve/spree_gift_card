FactoryGirl.define do
  factory :gift_card, class: Spree::GiftCard do
    email 'spree@example.com'
    name 'Example User'
    current_value 19.99
    original_value 19.99
    expiration_date Time.now + 2.months

    trait :redeemed do
      after :create do |gift_card|
        gift_card.current_value = 0.0
        gift_card.save!
      end
    end

    trait :expired do
      expiration_date Time.now - 1.day
    end

    trait :for_order do
      variant
      line_item
    end

    factory :gift_card_product, traits: [:for_order]
    factory :redeemed_gc, traits: [:redeemed]
    factory :expired_gc, traits: [:expired]
  end
end
