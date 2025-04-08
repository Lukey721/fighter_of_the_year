class VotesController < ApplicationController
  def new
    @fighters = Fighter.all
    @vote = Vote.new
  end

  def create
    @vote = Vote.new(vote_params)

    if @vote.save
      # Assuming you want to redirect to results from the backend itself
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