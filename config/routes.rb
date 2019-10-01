Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:new]
  resources :youtubers, only: [:index, :show]
  resources :likes, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
