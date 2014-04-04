FactoryGirl.define do
  factory :gift_card, class: Spree::GiftCard do
    email 'spree@example.com'
    name 'Example User'
    variant
    line_item
    expiration_date '2030-04-01'

    trait :expired do
      expiration_date Time.now - 1.day
    end

    factory :expired_gc, traits: [:expired]
  end
end
