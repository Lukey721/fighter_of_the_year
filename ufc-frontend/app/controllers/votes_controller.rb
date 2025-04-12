require 'json'
require 'faraday'

class VotesController < ApplicationController
  #before_action :set_auth_header
  before_action :require_login

  def new
    response = Faraday.get("http://voting-api:3000/fighters") do |req|
      req.headers['Authorization'] = @auth_header if @auth_header
    end

    if response.status == 200
      @fighters = JSON.parse(response.body)
    else
      flash[:alert] = "Could not fetch the list of fighters. Please try again."
      @fighters = []
    end
  end
 
  def create
    response = Faraday.post("http://voting-api:3000/votes") do |req|
      req.headers['Authorization'] = @auth_header if @auth_header
      req.headers['Content-Type'] = 'application/json'
      Rails.logger.info("Submitting vote as user_id: #{session[:user_id]}")
      req.body = {
        vote: {
         user_id: session[:user_id], # add the userid
          fighter_id: params[:vote][:fighter_id]
        }
      }.to_json
    end
  
    begin
      body = JSON.parse(response.body) if response.body.present?
  
      if response.status == 200
        redirect_to results_path, notice: "Vote submitted successfully!"
      elsif response.status == 403 && body["redirect_to"]
        redirect_to body["redirect_to"], alert: body["error"]
      else
        flash[:alert] = body["error"] || "Vote submission failed."
        render :new
      end
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse response: #{e.message}")
      flash[:alert] = "Unexpected error occurred. Please try again."
      render :new
    end
  end

  def results
    response = Faraday.get("http://voting-api:3000/results") do |req|
      req.headers['Authorization'] = @auth_header if @auth_header
    end

    if response.status == 200
      @results = JSON.parse(response.body)
    else
      flash[:alert] = "Could not fetch the voting results. Please try again."
      @results = []
    end
  end

  private

  #def set_auth_header
  #  token = session[:auth_token]
   # @auth_header = "Bearer #{token}" if token.present?
  #end
end