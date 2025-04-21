# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    it 'creates a new user' do
      post :create, params: { user: { name: 'John', email: 'john@example.com' } }
      expect(response).to have_http_status(:created)
      expect(User.last.name).to eq('John')
    end
  end
end
