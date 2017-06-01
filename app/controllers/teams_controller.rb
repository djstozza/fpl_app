class TeamsController < ApplicationController
  before_action :set_team, only: [:show]

  def index
    respond_to do |format|
      format.json { render json: TeamsDecorator.new(Team.all).all_data }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    respond_to do |format|
      format.html
      format.json do
        render json: {
          team: @team_decorator,
          fixtures: @team_decorator.fixture_hash,
          players: PlayersDecorator.new(@team_decorator.players).all_data
        }
      end
    end
  end

  private

  def set_team
    @team_decorator = TeamDecorator.new(Team.find(params[:id]))
  end
end
