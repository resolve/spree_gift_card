require "spec_helper"

describe Spree::GiftCardsController do
  let(:user) { create :user}
  login

  describe "get transfer" do
    subject { get :transfer, id: card.id, use_route: :spree }
    let!(:card) { create :gift_card, user: user }
    it { should be_success }
    it { should render_template :transfer }
  end

  describe "PUT update" do
    subject { put :update,
              id: card.id,
              gift_card: { email: email, note: "sup heres a gc" },
              use_route: :spree }

    let(:email) { "recipitent@email.com"}
    let!(:card) { create :gift_card, user: user }

    it { should be_redirect }

    it "has a success message" do
      subject
      flash[:success].should =~ /successfully sent gift card/
    end

    it "removes the gift card from the sender's account" do
      expect{ subject }.to change{ user.gift_cards.count }.by( -1 )
    end

    it "sends an email to the recipitent notifying them they've received a gift card" do
      mailer = double
      mailer.should_receive(:deliver)

      expect(Spree::GiftCardMailer).to receive(:gift_card_transferred).
        with(an_instance_of(Spree::GiftCard), user.email).and_return(mailer)

      subject
    end

    context "when the recipitent does have a matching user" do
      let!(:recipitent) { create :user, email: email }

      it "adds the gift card to the recipitent's account" do
        expect{subject}.to change{recipitent.gift_cards.count}.by( 1 )
      end
    end

    context "with invalid parameters" do
      before { allow_any_instance_of(Spree::GiftCard).
               to receive(:update_attributes).and_return(false) }

      it "it re-renders the action" do
        should render_template :transfer
      end
    end
  end

  describe "GET index" do
    subject { get :index, use_route: :spree }

    let!(:user) { create(:user) }
    let!(:gift_card) { create(:gift_card, user: user) }
    let!(:expired_gc) { create(:expired_gc, user: user) }

    before { allow(controller).to receive(:current_spree_user).and_return(user) }

    it { should render_template(:index) }
    it { should be_success }

    describe "sorting" do
      subject { get :index, use_route: :spree, show_all: "true" }

      let!(:gift_card_2) { create :gift_card, user: user, expiration_date: Time.current + 1.year }
      let!(:redeemed_gc) { create :redeemed_gc, user: user }

      it "sorts gift_cards by status, and then expiration_date" do
        subject
        expect(assigns(:gift_cards).count).to eq 4
        expect(assigns(:gift_cards).first).to eq gift_card_2
        expect(assigns(:gift_cards)[1]).to eq gift_card
        expect(assigns(:gift_cards)[-2]).to eq redeemed_gc
        expect(assigns(:gift_cards).last).to eq expired_gc
      end
    end

    context "when show_all query param isn't true" do
      it "doesn't include expired gift cards" do
        subject
        expect(assigns(:gift_cards).count).to eq 1
        expect(assigns(:gift_cards)).to_not include(expired_gc)
      end
    end

    context "when show_all query param is true" do
      subject { get :index, show_all: "true",
                use_route: :spree }

      it "includes expired gift cards as well" do
        subject
        expect(assigns(:gift_cards).count).to eq 2
        expect(assigns(:gift_cards)).to include(expired_gc)
      end
    end
  end
end
