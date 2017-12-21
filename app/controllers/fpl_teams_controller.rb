class FplTeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fpl_team, only: [:show, :edit, :update, :destroy]

  # GET /fpl_teams
  # GET /fpl_teams.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: UserDecorator.new(current_user).fpl_team_league_statuses }
    end
  end

  # GET /fpl_teams/1
  # GET /fpl_teams/1.json
  def show
    league_decorator = LeagueDraftPicksDecorator.new(@fpl_team.league)
    respond_to do |format|
      format.html
      format.json do
        render json: {
          fpl_team: @fpl_team,
          fpl_teams: league_decorator.fpl_teams,
          league: league_decorator,
          picked_players: league_decorator.picked_players,
          positions: Position.all,
          current_user: current_user
        }
      end
    end
  end

  # GET /fpl_teams/1/edit
  def edit
    @form = ::FplTeams::EditForm.new(fpl_team: @fpl_team, current_user: current_user)
  end

  # PATCH/PUT /fpl_teams/1
  # PATCH/PUT /fpl_teams/1.json
  def update
    respond_to do |format|
      if @fpl_team.update(fpl_team_params)
        format.html { redirect_to @fpl_team, notice: 'Fpl team was successfully updated.' }
        format.json { render :show, status: :ok, location: @fpl_team }
      else
        format.html { render :edit }
        format.json { render json: @fpl_team.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_fpl_team
    @fpl_team = FplTeam.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def fpl_team_params
    params.fetch(:fpl_team, keys: [:id, :name])
  end
end
