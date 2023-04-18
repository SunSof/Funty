Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  get 'users/new' => 'users#new', as: 'user_new'
  post 'users/new' => 'users#create'

  get 'users/:id' => 'users#show', as: 'user'

  get 'users/:id/edit' => 'users#edit', as: 'user_edit'
  patch 'users/:id' => 'users#update', as: 'user_update'

  delete 'users/:id' => 'users#destroy'

  get 'login' => 'user_sessions#new', as: 'login'
  post 'login' => 'user_sessions#create'
  post 'logout' => 'user_sessions#destroy', as: 'logout'

  get 'google_auth' => 'users#google_auth'
  post 'google_auth' => 'users#google_auth', as: 'sign_up_google'

  get 'google_auth/google-callback' => 'users#google_callback', as: 'callback'
  post 'google_auth/google-callback' => 'users#google_callback'
end
