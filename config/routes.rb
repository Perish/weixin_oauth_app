Rails.application.routes.draw do
  resources :weixin_users, only: [:index] do
  	collection do
  		get :code
  	end
  end

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
