class PositionsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: Position.all }
    end
  end
end
