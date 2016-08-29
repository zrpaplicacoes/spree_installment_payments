Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :zone_interests
  end
end
