# frozen_string_literal: true

Rails.application.routes.draw do
  post '/login', to: 'sessions#create'

  resources :users, only: %i[index show create update destroy] do
    patch 'update_admin_status', on: :member
  end
end
