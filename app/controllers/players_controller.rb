class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players
  # GET /players.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: Player.all.to_json(except: [:player_fixture_histories, :player_past_histories]) }
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    team_decorator = TeamDecorator.new(@player.team)
    respond_to do |format|
      format.html
      format.json { render json: { player: @player, team: team_decorator, team_fixtures: team_decorator.fixture_hash } }
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
