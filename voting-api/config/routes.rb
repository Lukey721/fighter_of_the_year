Rails.application.routes.draw do
  resources :votes, only: [:create, :index]
  get '/results', to: 'votes#results'
  resources :fighters, only: [:create,:index]
end