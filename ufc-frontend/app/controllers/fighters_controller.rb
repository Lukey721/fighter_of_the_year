require 'ostruct'
require 'json'
require 'faraday'

class FightersController < ApplicationController
  # Show the form to add a new fighter
  def new
    @fighter = OpenStruct.new
  end

  def list # list out fighters
    response = Faraday.get("http://voting-api:3000/fighters")

    if response.status == 200
      @fighters = JSON.parse(response.body)
    else
      flash[:alert] = "Could not fetch fighters."
      @fighters = []
    end
  end
  
  before_action :require_admin
  # Handle the fighter creation by sending data to the voting-api (backend)
  def create
    response = Faraday.post("http://voting-api:3000/fighters", {
      fighter: {
        name: params[:fighter][:name],
        ufc_id: params[:fighter][:ufc_id]
      }
    })

    if response.status == 201
      fighter_data = JSON.parse(response.body)
      redirect_to fighters_path, notice: "Fighter added successfully!"
    else
      flash[:alert] = "Fighter creation failed: #{response.body}"
      @fighter = OpenStruct.new(params[:fighter]) # repopulate the form
      render :new
    end
  end
end