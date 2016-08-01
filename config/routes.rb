Rails.application.routes.draw do
  resources :links, only: [:index, :create, :update]

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
