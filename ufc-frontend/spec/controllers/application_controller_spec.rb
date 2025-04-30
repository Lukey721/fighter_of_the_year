# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestController, type: :controller do
  describe '#current_user' do
    it 'returns current user based on session' do
      session[:user_id] = 1
      session[:user_email] = 'test@example.com'
      session[:is_admin] = true

      get :index

      user = controller.send(:current_user)
      expect(user.email).to eq('test@example.com')
      expect(user.is_admin).to be true
    end

    it 'returns nil if session user_id is missing' do
      session[:user_id] = nil
      get :index
      expect(controller.send(:current_user)).to be_nil
    end
  end

  describe '#require_login' do
    it 'redirects to login if not signed in' do
      get :private_action
      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to eq('You must be logged in to access this page.')
    end

    it 'allows access if signed in' do
      session[:user_id] = 1
      get :private_action
      expect(response.body).to include('Private Access OK')
    end
  end

  describe '#require_admin' do
    it 'redirects to root if not admin' do
      session[:user_id] = 1
      session[:is_admin] = false

      get :admin_action
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('You must be an admin to view this page.')
    end

    it 'allows access if admin' do
      session[:user_id] = 1
      session[:is_admin] = true

      get :admin_action
      expect(response.body).to include('Admin Access OK')
    end
  end
end
