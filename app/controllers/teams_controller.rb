class TeamsController < ApplicationController
  before_action :set_team, only: [:show]

  def index
    respond_to do |format|
      format.json { render json: Team.all.order(:position).each { |team| TeamDecorator.new(team) } }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    respond_to do |format|
      format.html
      format.json do
        render json: { team: @team_decorator, fixtures: @team_decorator.fixture_hash, players: @team_decorator.players }
      end
    end
  end

  private

  def set_team
    @team_decorator = TeamDecorator.new(Team.find(params[:id]))
  end
end
