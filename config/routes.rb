Spree::Core::Engine.routes.draw do
  resources :gift_cards, except: [:edit] do
    member do
      get :send_to_friend
      patch :transfer
    end
  end

  namespace :admin do
    resources :gift_cards do
      member do
        put :void
        put :restore
      end
    end

    resources :adjustments do
      member do
        post :refund_gc
      end
    end
  end
end
