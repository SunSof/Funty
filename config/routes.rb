Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'pages#index'

  get 'users/new' => 'users#new', as: 'user_new'
  post 'users/new' => 'users#create'

  get 'users/:id' => 'users#show', as: 'user'

  get 'users/:id/edit' => 'users#edit', as: 'user_edit'
  patch 'users/:id' => 'users#update', as: 'user_update'

  delete 'users/:id' => 'users#destroy'

  get 'users/:id/statistics' => 'users#statistics', as: 'user_stat'
  get 'users/:id/wallet' => 'users#wallet', as: 'wallet'
  get 'users/:id/invoice' => 'users#invoice', as: 'invoice'

  get 'login' => 'user_sessions#new', as: 'login'
  post 'login' => 'user_sessions#create'
  post 'logout' => 'user_sessions#destroy', as: 'logout'

  get 'google_auth' => 'users#google_auth'
  post 'google_auth' => 'users#google_auth', as: 'sign_up_google'

  get 'google_auth/google-callback' => 'users#google_callback', as: 'callback'
  post 'google_auth/google-callback' => 'users#google_callback'

  get 'games/new' => 'games#new', as: 'new_game'

  post 'games/choose' => 'games#choose', as: 'choose'
  post 'games/result' => 'games#result', as: 'result'
end
