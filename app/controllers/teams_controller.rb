class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :team_player_datatable]

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  def team_ladder_datatable
    render_datatable_json(TeamsDatatable)
  end

  def team_player_datatable
    position = Position.find_by(singular_name: params[:position])
    render_datatable_json(TeamPlayersDatatable, @team, position)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end
end
