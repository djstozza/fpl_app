class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :team_player_datatable, :team_fixture_datatable]
  
  # GET /teams/1
  # GET /teams/1.json
  def show
    @fixture_hash = @team_decorator.fixture_hash
  end

  def team_ladder_datatable
    @teams = Team.all.order(:position).each { |team| TeamDecorator.new(team) }
    respond_to do |format|
      format.json do
        render json: Team.all
                         .order(:position)
                         .each { |team| TeamDecorator.new(team) }
      end
    end
  end

  def team_player_datatable
    render_datatable_json(TeamPlayersDatatable, @team_decorator, Position.find_by(singular_name: params[:position]))
  end

  def team_fixture_datatable
    @fixture_hash = @team_decorator.fixture_hash
    respond_to do |format|
      format.json do
        render json: { team: @team_decorator, fixtures: @team_decorator.fixture_hash }
      end
    end
  end

  private

  def set_team
    @team_decorator = TeamDecorator.new(Team.find(params[:id]))
  end
end
