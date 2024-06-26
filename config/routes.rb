require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # When you boot up the server with rails s, you can navigate to localhost:3000/sidekiq to access the web UI.
  mount Sidekiq::Web => '/sidekiq'

  root 'pages#index'
  get 'pages/help' => 'pages#help', as: 'help'

  get 'users/new' => 'users#new', as: 'user_new'
  post 'users/new' => 'users#create'

  get 'users/:id' => 'users#show', as: 'user'

  get 'users/:id/edit' => 'users#edit', as: 'user_edit'
  patch 'users/:id' => 'users#update', as: 'user_update'

  delete 'users/:id' => 'users#destroy'

  get 'users/:id/statistics' => 'users#statistics', as: 'user_stat'
  get 'users/:id/wallet' => 'users#wallet', as: 'wallet'

  get 'users/:id/app_invoice' => 'users#app_invoice', as: 'app_invoice'

  get 'users/:id/user_invoice' => 'users#user_invoice'
  post 'users/:id/user_invoice' => 'users#user_invoice', as: 'user_invoice'

  get 'login' => 'user_sessions#new', as: 'login'
  post 'login' => 'user_sessions#create'
  post 'logout' => 'user_sessions#destroy', as: 'logout'

  get 'google_auth' => 'users#google_auth'
  post 'google_auth' => 'users#google_auth', as: 'sign_up_google'

  get 'google_auth/google-callback' => 'users#google_callback', as: 'callback'
  post 'google_auth/google-callback' => 'users#google_callback'

  get 'games/new' => 'games#new', as: 'new_game'
  get 'games/start' => 'games#start', as: 'start'
  post 'games/restart' => 'games#restart', as: 'restart'

  post 'games/choose' => 'games#choose', as: 'choose'
  post 'games/result' => 'games#result', as: 'result'
end
