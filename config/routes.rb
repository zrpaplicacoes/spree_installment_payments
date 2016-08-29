Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :zone_interests, only: [:index, :new, :create, :show]
  end
end
