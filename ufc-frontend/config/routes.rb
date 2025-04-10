Rails.application.routes.draw do
  root "users#new"

  get '/login', to: 'sessions#login'
  post '/sessions', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # Routes for user registration
  post '/login', to: 'users#login'
  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get '/thank_you', to: 'users#thank_you'

  # Routes for votes and results
  get "/votes", to: "votes#new"
  post "/votes", to: "votes#create"
  get "/results", to: "votes#results"

  # Routes for fighters
  get "/fighters", to: "fighters#new"
  post "/fighters", to: "fighters#create"
  get '/fighters/list', to: 'fighters#list'

  # Resources for users and fighters
  resources :users, only: [:new, :create]  # Only new and create actions for users
  resources :fighters, only: [:new,:index]      # Only index action for fighters
end