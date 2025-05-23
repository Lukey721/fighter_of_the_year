# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  get '/login', to: 'sessions#login'
  post '/sessions', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Routes for user registration
  post '/login', to: 'users#login'
  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/thank_you', to: 'users#thank_you'

  # Admin actions
  get 'admin/users', to: 'admin#users'
  patch 'admin/users/:id', to: 'admin#update', as: 'update_user_admin_status'
  delete 'admin/users/:id', to: 'admin#destroy', as: 'delete_user'

  # Routes for votes and results
  get '/votes', to: 'votes#new'
  post '/votes', to: 'votes#create'
  get '/results', to: 'votes#results'

  # Routes for fighters
  get '/fighters', to: 'fighters#new'
  post '/fighters', to: 'fighters#create'
  get '/fighters/list', to: 'fighters#list'

  # Resources for users and fighters
  resources :users, only: %i[new create] # Only new and create actions for users
  resources :fighters, only: %i[new index] # Only index action for fighters

  if Rails.env.test?
    get 'test', to: 'test#index'
    get 'test/private_action', to: 'test#private_action'
    get 'test/admin_action', to: 'test#admin_action'
  end
end
