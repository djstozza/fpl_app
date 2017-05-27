class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players
  # GET /players.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: Player.all }
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: @player.fixture_stats }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def player_params
    params.fetch(:player, {})
  end
end
