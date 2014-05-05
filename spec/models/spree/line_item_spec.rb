require 'spec_helper'

describe Spree::LineItem do
  describe "validations" do
    subject do
      line_item = FactoryGirl.build(:gift_card_product).line_item
      line_item.product.stub(:is_gift_card?) { true }
      line_item
    end

    it { should have_one(:gift_card).dependent(:destroy) }
    it { should validate_presence_of(:gift_card) }
    it { should validate_numericality_of(:quantity).is_less_than_or_equal_to(1) }
  end

  describe "#associate_gift_card" do
    let!(:line_item) { create :line_item }
    let!(:gc) { create :gift_card, line_item: line_item, user: nil, email: user_email}
    let(:deliver_double) { double deliver: true }
    let(:user_email) { Spree::User.first.email }
    subject { line_item.associate_gift_card }

    it "sends the gift card email" do
      expect(Spree::OrderMailer).to receive(:gift_card_email).
        with(gc.id, line_item.order.id).
        and_return(deliver_double)
      subject
    end

    context "when a user by the email on the gift card exists" do
      it "tells the gift card to associate itself with a user" do
        expect(line_item.gift_card).to receive(:associate_user!).once.
          with(line_item.order.user)
        subject
      end
    end

    context "when a user by the email on the gift card does not exist" do
      let(:user_email) { "sdfsdfsfsfgs@sdgsadfs.ca" }
      it "does not try to associate the gift card with a user" do
        expect(line_item.gift_card).to_not receive(:associate_user)
        subject
      end
    end
  end
end
