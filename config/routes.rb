Rails.application.routes.draw do
  resources :links
  devise_for :users
  root 'links#new'
  get '/dashboard', to: 'dashboard#index'
  
  get '/:short_url', to: 'links#redirect_to_original', as: :redirect_to_original
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
