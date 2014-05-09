require 'spec_helper'

describe Spree::User do
  describe "#available_gift_cards" do
    let(:user) { create :user }
    let(:order) { create :order, user: user }

    subject { order.available_gift_cards }

    context "for a user with a expired gift card that has a value" do
      let!(:gift_card) { create :expired_gc, user: user }

      it "isn't included in the results" do
        expect(subject.to_a).to be_empty
      end
    end

    context "for a user with a unexpired gift card that has no value" do
      let!(:gift_card) { create :redeemed_gc, user: user }

      it "isn't included in the results" do
        expect(subject.to_a).to be_empty
      end
    end

    context "for a user with a gift card that has value and is unexpired" do
      let!(:gift_card) { create :gift_card, user: user }

      it "is included in the results" do
        expect(subject.to_a).to eql([gift_card])
      end
    end
  end
end
