class TradesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team, only: [:create]

  # POST /trades
  # POST /trades.json
  def create
    list_position = ListPosition.find_by(id: params[:list_position_id])
    target = Player.find_by(id: params[:target_id])
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: @fpl_team,
      list_position: list_position,
      target: target,
      current_user: current_user
    )
    respond_to do |format|
      if form.save
        league_decorator = LeagueDecorator.new(@fpl_team.league)
        format.json do
          render json: {
            line_up: ListPositionsDecorator.new(@fpl_team.fpl_team_lists.first.list_positions).list_position_arr,
            players: @fpl_team.players,
            unpicked_players: league_decorator.unpicked_players,
            picked_players: league_decorator.picked_players,
            success: "You have successfully traded out #{list_position.player.name} for #{target.name}"
          }
        end
      else
        format.json { render json: form.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fpl_team
    @fpl_team = FplTeam.find_by(id: params[:fpl_team_id])
  end
end
