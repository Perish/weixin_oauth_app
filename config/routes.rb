Rails.application.routes.draw do
  resources :qrcodes

  resources :links

  get "weixin/:id/receive" => "weixin#auth"
  post "weixin/:id/receive" => "weixin#receive"

  resources :weixin_users, only: [:index, :create] do
  	collection do
  		get :code
  	end
  end

  get 'login' => "sessions#new"
  post 'login' => "sessions#create"

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
