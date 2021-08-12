Rails.application.routes.draw do

  root to: 'lists#index'

  resources :cards
  resources :lists
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
