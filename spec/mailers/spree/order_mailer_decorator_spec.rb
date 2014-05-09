require 'spec_helper'

describe Spree::OrderMailer do
  describe "#gift_card_email" do
    let(:gift_card) { create :gift_card }
    let(:order) { build :order }
    subject { described_class.gift_card_email(gift_card, order) }

    its(:subject) { should eql(Spree::Config[:site_name] + " Gift Card") }
    its(:to) { should eql([gift_card.email]) }
    its(:from) { should eql(["spree@example.com"]) }

    it "updates the gift cards sent at" do
      allow(Time).to receive(:now).and_return(Time.at(1399590448))
      expect(gift_card).to receive(:update_attribute).with(:sent_at, Time.at(1399590448))
      subject
    end
  end
end
