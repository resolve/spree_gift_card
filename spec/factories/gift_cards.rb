FactoryGirl.define do
  factory :gift_card, class: Spree::GiftCard do
    email 'spree@example.com'
    name 'Example User'
    variant
    line_item
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

    factory :redeemed_gc, traits: [:redeemed]
    factory :expired_gc, traits: [:expired]
  end
end
