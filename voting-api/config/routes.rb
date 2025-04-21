# frozen_string_literal: true

Rails.application.routes.draw do
  resources :votes, only: %i[create index]
  get '/results', to: 'votes#results'
  resources :fighters, only: %i[create index]
end
