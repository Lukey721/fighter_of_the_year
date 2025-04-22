# frozen_string_literal: true

# This is to test a user can register and fail registration
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    let(:valid_user_params) do
      {
        user: {
          name: 'Testing User',
          email: 'testinguser1@example.com',
          password: 'coolpass123',
          password_confirmation: 'coolpass123'
        }
      }
    end

    it 'redirects to thank_you page on success' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 201, body: { name: 'Testing User', email: 'testinguser1@example.com' }.to_json)
      )

      post :create, params: valid_user_params

      expect(response).to redirect_to(thank_you_path(name: 'Testing User', email: 'testinguser1@example.com'))
      puts "Registration Test - Successful Registration Redirect: #{response.status} → #{response.location}"
    end

    # Mock registration unsucessful as email already in use 
    it 're-renders new form on API error' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 422, body: 'Email already taken')
      )

      post :create, params: valid_user_params

      expect(response).to render_template(:new)
      expect(assigns(:user)).to be_a(OpenStruct)
      expect(flash[:alert]).to include('Registration failed')
      puts "Registration Test - Failed Registration Alert: #{flash[:alert]}"
    end
  end
end