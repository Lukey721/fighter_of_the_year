# frozen_string_literal: true

require 'json'
require 'faraday'

class HomeController < ApplicationController
  def index
    response = Faraday.get('http://voting-api:3000/fighters')

    if response.status == 200
      @fighters = JSON.parse(response.body)
    else
      flash[:alert] = 'Could not load fighters.'
      @fighters = []
    end
  end
end
