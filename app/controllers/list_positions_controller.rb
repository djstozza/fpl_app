class ListPositionsController < ApplicationController
  respond_to :json
  before_action :set_list_position, only: [:show]

  # GET /list_positions/1
  # GET /list_positions/1.json
  def show
    render json: { options: ListPositionDecorator.new(@list_position).substitute_options }
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list_position
    @list_position = ListPosition.find(params[:id])
  end
end
