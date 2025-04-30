# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FightersController, type: :controller do
  before do
    allow(controller).to receive(:require_admin).and_return(true)
  end

  describe 'GET #new' do
    it 'initializes a new fighter' do
      get :new
      expect(assigns(:fighter)).to be_a(OpenStruct)
      expect(response).to be_successful
    end
  end

  describe 'GET #list' do
    it 'assigns fighters on success' do
      allow(Faraday).to receive(:get).and_return(
        instance_double(Faraday::Response, status: 200, body: [{ name: 'McGregor' }].to_json)
      )

      get :list

      expect(assigns(:fighters)).to be_an(Array)
    end

    it 'shows flash alert on failure' do
      allow(Faraday).to receive(:get).and_return(
        instance_double(Faraday::Response, status: 500)
      )

      get :list

      expect(flash[:alert]).to eq('Could not fetch fighters.')
      expect(assigns(:fighters)).to eq([])
    end
  end

  describe 'POST #create' do
    let(:fighter_params) do
      {
        fighter: {
          name: 'Jon Jones',
          ufc_id: '123'
        }
      }
    end

    it 'redirects on successful creation' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 201, body: {}.to_json)
      )

      post :create, params: fighter_params

      expect(response).to redirect_to(fighters_path)
      expect(flash[:notice]).to eq('Fighter added successfully!')
    end

    it 're-renders on failure' do
      allow(Faraday).to receive(:post).and_return(
        instance_double(Faraday::Response, status: 422, body: 'Error')
      )

      post :create, params: fighter_params

      expect(response).to render_template(:new)
      expect(assigns(:fighter)).to be_a(OpenStruct)
      expect(flash[:alert]).to include('Fighter creation failed')
    end
  end
end
