class FightersController < ApplicationController
  # before_action :authenticate_user! # for auth of admin user later
  def index
    @fighters = Fighter.all
    render json: @fighters
  end

  # this is essentailly the post
  def create
    @fighter = Fighter.new(fighter_params)
    
    if @fighter.save
      render json: @fighters, status: :created
    else
      render json: { errors: @fighters.errors }, status: :unprocessable_entity
    end
  end

  private

  def fighter_params
    params.require(:fighter).permit(:name, :ufc_id)
  end
end