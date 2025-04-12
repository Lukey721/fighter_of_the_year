class VotesController < ApplicationController
  # before_action :authenticate_user, only: [:create]

  def new
    Rails.logger.info("Auth token: #{session[:auth_token]}")
    @fighters = Fighter.all
    @vote = Vote.new
  end

  def create

    user_id = params[:vote][:user_id]

    # Check if the user has already voted
    existing_vote = Vote.find_by(user_id: user_id)
    if existing_vote
      render json: {
        error: "You have already voted.",
        redirect_to: results_path
      }, status: :forbidden
      return
    end

    @vote = Vote.new(vote_params.merge(user_id: params[:vote][:user_id]))  # Get user_id directly from params
    if @vote.save
      render json: { redirect_to: results_path }, status: :ok
    else
      render json: { errors: @vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def results
    @results = Fighter.joins(:votes)
                      .group('fighters.id')
                      .select('fighters.name, COUNT(votes.id) AS vote_count')
                      .order('vote_count DESC')

    # Instead of rendering raw ActiveRecord objects, return as JSON:
    render json: @results, status: :ok
  end

  private

  def vote_params
    params.require(:vote).permit(:user_id, :fighter_id)  # Ensure we allow user_id and fighter_id
  end
end