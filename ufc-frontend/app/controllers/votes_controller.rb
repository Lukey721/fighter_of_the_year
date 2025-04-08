require 'json'
require 'faraday'

class VotesController < ApplicationController
  def new
    # Fetch the list of fighters for voting (using Faraday)
    response = Faraday.get("http://voting-api:3000/fighters")
    
    # Parse response if status is 200, otherwise show an alert
    if response.status == 200
      @fighters = JSON.parse(response.body)
    else
      flash[:alert] = "Could not fetch the list of fighters. Please try again."
      @fighters = []  # Ensure @fighters is set, even if there's an error
    end
  end

  def create
    # Send the vote to the backend API
    response = Faraday.post("http://voting-api:3000/votes", {
      vote: {
        user_id: params[:vote][:user_id],
        fighter_id: params[:vote][:fighter_id]
      }
    })
  
    # Check if the response is valid and parse the body
    if response.status == 200 && response.body.present?
      begin
        parsed_response = JSON.parse(response.body)
        
        # Assuming the backend sends a redirect to results, we can redirect here
        redirect_to results_path, notice: "Vote submitted successfully!"
      rescue JSON::ParserError => e
        # If JSON parsing fails, log the error and show a message
        Rails.logger.error("Failed to parse response: #{e.message}")
        flash[:alert] = "Something went wrong. Please try again."
        render :new
      end
    else
      # Handle errors when the response is empty or invalid
      flash[:alert] = "Vote submission failed: #{response.body}"
      render :new
    end
  end

  def results
    # Fetch the voting results from the API (assuming this is a JSON response)
    response = Faraday.get("http://voting-api:3000/results")
    
    if response.status == 200
      @results = JSON.parse(response.body)
    else
      flash[:alert] = "Could not fetch the voting results. Please try again."
      @results = []  # Ensure @results is set, even if there's an error
    end
  end
end