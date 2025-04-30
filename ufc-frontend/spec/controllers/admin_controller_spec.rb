# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  before do
    allow(controller).to receive(:require_admin).and_return(true)
  end

  describe 'GET #users' do
    it 'assigns users on successful API call' do
      allow(Faraday).to receive(:get).and_return(
        instance_double(Faraday::Response, status: 200, body: [{ id: 1, name: 'Luke' }].to_json)
      )

      get :users

      expect(assigns(:users)).to be_an(Array)
      expect(response).to be_successful
    end

    it 'assigns empty array and flash on API failure' do
      allow(Faraday).to receive(:get).and_return(
        instance_double(Faraday::Response, status: 500, body: 'Error')
      )

      get :users

      expect(assigns(:users)).to eq([])
      expect(flash[:alert]).to eq('Could not fetch users.')
    end
  end

  describe 'PATCH #update' do
    it 'redirects with notice on success' do
      allow(Faraday).to receive(:patch).and_return(
        instance_double(Faraday::Response, status: 200, success?: true, body: '')
      )

      patch :update, params: { id: 1 }

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('User admin status updated successfully.')
    end

    it 'redirects with alert on failure' do
      allow(Faraday).to receive(:patch).and_return(
        instance_double(Faraday::Response, status: 500, success?: false, body: 'Failed')
      )

      patch :update, params: { id: 1 }

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:alert]).to eq('Failed to update admin status.')
    end
  end

  describe 'DELETE #destroy' do
    it 'redirects with notice on success' do
      allow(Faraday).to receive(:delete).and_return(
        instance_double(Faraday::Response, status: 200, success?: true)
      )

      delete :destroy, params: { id: 1 }

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('User deleted successfully.')
    end

    it 'redirects with alert on failure' do
      allow(Faraday).to receive(:delete).and_return(
        instance_double(Faraday::Response, status: 500, success?: false)
      )

      delete :destroy, params: { id: 1 }

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:alert]).to eq('Failed to delete user.')
    end
  end
end
