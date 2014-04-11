Spree::Core::Engine.routes.draw do
  resources :gift_cards

  resource :account, controller: 'users' do
    resources :gift_cards
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
