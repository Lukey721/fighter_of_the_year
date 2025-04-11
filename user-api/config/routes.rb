Rails.application.routes.draw do
  post "/login", to: "sessions#create"
  
  resources :users, only: [:index, :show, :create, :update, :destroy] do
    patch 'update_admin_status', on: :member
  end
end