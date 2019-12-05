Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:new]
  get 'youtubers/genle' => 'youtubers#genle'
  get 'youtubers/category' => 'youtubers#category'
  get 'youtubers/subscriber_ranking' => 'youtubers#subscriber_ranking'
  get 'youtubers/home' => 'youtubers#home'
  #autocomplete機能のルートを設定
  resources :youtubers do
    get :autocomplete_youtuber_name, on: :collection # 追加
  end
  post 'youtubers/category_search' => 'yuoubers#category_search'
  resources :youtubers, only: [:index, :show]
  resources :likes, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
