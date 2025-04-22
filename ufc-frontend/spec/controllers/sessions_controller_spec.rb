# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let(:valid_credentials) do
      {
        email: 'testinguser1@example.com',
        password: 'coolpass123'
      }
    end

    it 'user logs in successfully and sets session' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 200, body: {
          token: 'fake-jwt-token',
          email: 'testinguser1@example.com',
          id: 10,
          is_admin: true
        }.to_json)
      )

      post :create, params: valid_credentials

      expect(session[:auth_token]).to eq('fake-jwt-token')
      expect(session[:user_email]).to eq('testinguser1@example.com')
      expect(session[:user_id]).to eq(10)
      expect(session[:is_admin]).to be true
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Logged in as testinguser1@example.com')

      puts "Login Test - Sucessful login session info: #{session.inspect}"
    end

    it 'user fails login and re-renders login page' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 401, body: 'Invalid credentials')
      )

      post :create, params: valid_credentials

      expect(session[:auth_token]).to be_nil
      expect(response).to render_template(:login)
      expect(flash[:alert]).to eq('Invalid email or password')
      expect(response).to have_http_status(:unauthorized)

      puts "Login Test - Failed Login: #{flash[:alert]}"
    end
  end
end