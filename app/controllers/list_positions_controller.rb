class ListPositionsController < ApplicationController
  before_action :set_list_position, only: [:show]

  # GET /list_positions/1
  # GET /list_positions/1.json
  def show
    respond_to do |format|
      format.json { render json: { options: ListPositionDecorator.new(@list_position).substitute_options } }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list_position
    @list_position = ListPosition.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def list_position_params
    params.fetch(:list_position, {})
  end
end
