Rails.application.routes.draw do

  root to: 'lists#index'

  resources :cards
  resources :lists do
    member do
      patch :move
    end
  end
end
