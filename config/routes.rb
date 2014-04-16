Spree::Core::Engine.routes.draw do
  resources :gift_cards, except: [:edit] do
    member do
      get :send_to_friend
    end
    member do
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
  end
end
