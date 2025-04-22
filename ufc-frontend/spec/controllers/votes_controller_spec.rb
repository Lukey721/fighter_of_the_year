# frozen_string_literal: true

# This is to test that a user can cast a vote
require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create' do
    before do
      session[:user_id] = 1 # Simulate a user logged-in user
    end

    let(:valid_vote_params) do
      {
        vote: {
          fighter_id: 420
        }
      }
    end

    it 'redirects to results on success' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 200, body: { message: 'Vote submitted successfully' }.to_json)
      )

      post :create, params: valid_vote_params

      expect(response).to redirect_to(results_path)
      expect(flash[:notice]).to eq('Vote submitted successfully!')
      puts "Voting Test - Successful Redirect - vote submitted sucessfully: #{response.status} → #{response.location}"
    end

    it 'redirects to login if API returns 403 with redirect' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 403, body: {
          redirect_to: '/login',
          error: 'You must be logged in'
        }.to_json)
      )

      post :create, params: valid_vote_params

      expect(response).to redirect_to('/login')
      expect(flash[:alert]).to eq('You must be logged in')
      puts "Voting Test - User not logged in: #{response.location}"
    end

    it 're-renders new if response contains error but no redirect' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 422, body: { error: 'Fighter not found' }.to_json)
      )

      post :create, params: valid_vote_params

      expect(response).to render_template(:new)
      expect(flash[:alert]).to eq('Fighter not found')
      puts "Voting Test - Re-render form when there is an error: #{flash[:alert]}"
    end

    it 'handles JSON parse errors' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 500, body: 'not-json')
      )

      post :create, params: valid_vote_params

      expect(response).to render_template(:new)
      expect(flash[:alert]).to eq('Unexpected error occurred. Please try again.')
      puts "Voting Test - JSON Parse Error Handling: #{flash[:alert]}"
    end
  end
end