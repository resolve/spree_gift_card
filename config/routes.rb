Spree::Core::Engine.routes.draw do
  resources :gift_cards, except: [:edit]

  namespace :admin do
    resources :gift_cards do
      member do
        put :void
        put :restore
      end
    end
  end
end
