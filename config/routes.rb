Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  get 'users/new' => 'users#new', as: 'user_new'
  post 'users/new' => 'users#create'
end
