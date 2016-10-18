Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :interests
  end
end
