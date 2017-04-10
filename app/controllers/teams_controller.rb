class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :team_player_datatable, :team_fixture_datatable]

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  def team_ladder_datatable
    render_datatable_json(TeamsDatatable)
  end

  def team_player_datatable
    render_datatable_json(TeamPlayersDatatable, @team_decorator, Position.find_by(singular_name: params[:position]))
  end

  def team_fixture_datatable
    render_datatable_json(TeamFixturesDatatable, @team_decorator)
  end

  private

  def set_team
    @team_decorator = TeamDecorator.new(Team.find(params[:id]))
  end
end
