# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    it 'assigns fighters on success' do
      allow(Faraday).to receive(:get).and_return(
        instance_double(Faraday::Response, status: 200, body: [{ name: 'Volkanovski' }].to_json)
      )

      get :index

      expect(assigns(:fighters)).to be_an(Array)
    end

    it 'shows flash on failure' do
      allow(Faraday).to receive(:get).and_return(
        instance_double(Faraday::Response, status: 500, body: 'Error')
      )

      get :index

      expect(assigns(:fighters)).to eq([])
      expect(flash[:alert]).to eq('Could not load fighters.')
    end
  end
end
