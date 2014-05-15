module Spree
  class GiftCardsController < Spree::StoreController
    before_filter :ensure_user, only: [:index, :send_to_friend, :transfer]
    before_filter :find_gift_card, only: [:send_to_friend, :transfer]

    def new
      @gift_card_variants = gift_card_variants
      @gift_card = GiftCard.new
    end

    def index
      @gift_cards = current_spree_user.gift_cards.order("expiration_date DESC")
      @gift_cards = @gift_cards.active unless params[:show_all]

      @gift_cards.sort! do |a, b|
        comp = gc_sort_order[a.status] <=> gc_sort_order[b.status]
        comp.zero?? (b.expiration_date <=> a.expiration_date) : comp
      end
    end

    def send_to_friend
    end

    def transfer
      transfer_params = params.require(:gift_card).permit(:note, :email, :transfer_amount, :name)
      additional_params = {
        expiration_date: @gift_card.expiration_date,
        user_id: Spree::User.find_by_email(transfer_params[:email]).try(:id)
      }

      new_gift_card = Spree::GiftCard.new transfer_params.merge(additional_params)
      @gift_card.current_value -= new_gift_card.transfer_amount.to_d

      unless @gift_card.valid? && new_gift_card.valid?
        flash.now[:error] = if @gift_card.errors.any?
                              Spree.t(:insufficient_balance)
                            else
                              new_gift_card.errors.full_messages.join(", ")
                            end

        render :send_to_friend
        return
      end

      @gift_card.save!
      new_gift_card.save!
      @gift_card.gift_card_transfers.create!(destination: new_gift_card)
      Spree::GiftCardMailer.gift_card_transferred(new_gift_card,
                                                  current_spree_user.email).deliver

      flash[:success] = Spree.t(:successfully_transferred_gift_card,
                                email: new_gift_card.email)
      redirect_to gift_cards_path
    end

    def create
      begin
        # Wrap the transaction script in a transaction so it is an atomic operation
        @gift_card = GiftCard.new(gift_card_params)
        Spree::GiftCard.transaction do
          @gift_card.save!
          order = current_order(create_order_if_necessary: true)
          line_item = LineItem.create!(order: order, quantity: 1, gift_card: @gift_card, variant: @gift_card.variant, price: @gift_card.variant.price)
          order.update_totals
          order.save!
          @gift_card.update!(line_item: line_item)
        end

        redirect_to cart_path
      rescue ActiveRecord::RecordInvalid
        @gift_card_variants = gift_card_variants
        render :new
      end
    end

    private

    def ensure_user
      redirect_to spree.login_path, notice: Spree.t(:login_required) unless current_spree_user
    end

    def gift_card_variants
      Spree::Variant.joins(:product).
        where(spree_products: { is_gift_card: true}).
        joins(:prices).where("spree_prices.amount > 0")
    end

    def gift_card_params
      params.require(:gift_card).permit(:email, :name, :note, :variant_id)
    end

    def gc_sort_order
      {
        active: 1,
        redeemed: 2,
        expired: 3
      }
    end

    def find_gift_card
      @gift_card = current_spree_user.gift_cards.where(id: params[:id]).first
    end
  end
end
