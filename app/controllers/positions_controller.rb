class PositionsController < ApplicationController
  respond_to :json

  def index
    render json: Position.all
  end
end
