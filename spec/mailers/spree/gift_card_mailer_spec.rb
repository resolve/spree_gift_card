require "spec_helper"

describe Spree::GiftCardMailer do
  describe ".gift_card_transferred" do
    let(:gift_card) { create(:gift_card) }

    it 'sends email to Gift Card Email' do
      mail = Spree::GiftCardMailer.gift_card_transferred gift_card, "spree@example.com"
      mail.to.should == [gift_card.email]
    end
  end
  describe ".gift_card_issued" do
    let(:gift_card) { create(:gift_card) }

    it 'sends email to Gift Card Email' do
      mail = Spree::GiftCardMailer.gift_card_issued gift_card
      mail.to.should == [gift_card.email]
    end
  end
  describe ".gift_card_expiring" do
    let(:gift_card) { create(:gift_card) }

    it 'sends email to Gift Card Email' do
      mail = Spree::GiftCardMailer.gift_card_expiring gift_card
      mail.to.should == [gift_card.email]
    end
  end

  describe ".gc_refund_email" do
    let(:gift_card) { build_stubbed(:gift_card) }
    let(:order) { build_stubbed(:order) }

    subject { described_class.gc_refund_email gift_card, order }

    its(:to) { should eql([gift_card.email]) }
    its(:encoded) { should match("This email is to inform you we have credited") }
  end
end
