Rails.application.routes.draw do
  root "users#new"
  
  # Routes for user registration
  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get '/thank_you', to: 'users#thank_you'

  # Routes for votes and results
  get "/votes", to: "votes#new"
  post "/votes", to: "votes#create"
  get "/results", to: "votes#results"

  # Resources for users and fighters
  resources :users, only: [:new, :create]  # Only new and create actions for users
  resources :fighters, only: [:index]      # Only index action for fighters
end