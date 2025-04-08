class FightersController < ApplicationController
  def index
    @fighters = Fighter.all
    render json: @fighters
  end
end