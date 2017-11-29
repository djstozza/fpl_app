class TradesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team, only: :create
  respond_to :json

  # POST /trades
  # POST /trades.json
  def create
    form = ::FplTeams::ProcessTradeForm.run(params.merge(current_user: current_user))
    league_decorator = LeagueDraftPicksDecorator.new(@fpl_team.league)
    fpl_team_list = form.list_position.fpl_team_list

    if form.valid?
        render json: {
          fpl_team_list: fpl_team_list,
          line_up: ListPositionsDecorator.new(fpl_team_list.list_positions).list_position_arr,
          players:  PlayersDecorator.new(@fpl_team.players).all_data,
          unpicked_players: league_decorator.unpicked_players,
          picked_players: league_decorator.picked_players,
          success: "You have successfully traded out #{form.out_player.name} for #{form.in_player.name}"
        }
    else
      render json: { errors: form.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fpl_team
    @fpl_team = FplTeam.find_by(id: params[:fpl_team_id])
  end
end
