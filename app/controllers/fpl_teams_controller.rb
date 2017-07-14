class FplTeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fpl_team, only: [:show, :edit, :update, :destroy]

  # GET /fpl_teams
  # GET /fpl_teams.json
  def index
    @fpl_teams = FplTeam.all
  end

  # GET /fpl_teams/1
  # GET /fpl_teams/1.json
  def show
    fpl_team_lists = @fpl_team.fpl_team_lists
    if fpl_team_lists.empty?
      fpl_team_list = ''
      line_up = []
      rounds = []
      round = ''
    else
      rounds_decorator = RoundsDecorator.new(Round.where(id: fpl_team_lists.pluck(:round_id)))
      rounds = rounds_decorator.all_data
      round = rounds_decorator.current_round
      fpl_team_list = fpl_team_lists.find_by(round_id: round.id)
      line_up = ListPositionsDecorator.new(fpl_team_list.list_positions).list_position_arr
    end
    league_decorator = LeagueDecorator.new(@fpl_team.league)

    respond_to do |format|
      format.html
      format.json do
        render json: {
          fpl_team: @fpl_team,
          fpl_team_list: fpl_team_list,
          league: @fpl_team.league,
          round: round,
          rounds: rounds,
          editable: true,
          fpl_team_lists: fpl_team_lists,
          line_up: line_up,
          waiver_picks: @fpl_team.waiver_picks.where(round_id: round.id),
          unpicked_players: league_decorator.unpicked_players,
          picked_players: league_decorator.picked_players,
          positions: Position.all,
          current_user: current_user
        }
      end
    end
  end

  # GET /fpl_teams/1/edit
  def edit
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

  # DELETE /fpl_teams/1
  # DELETE /fpl_teams/1.json
  def destroy
    @fpl_team.destroy
    respond_to do |format|
      format.html { redirect_to fpl_teams_url, notice: 'Fpl team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fpl_team
      @fpl_team = FplTeam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fpl_team_params
      params.fetch(:fpl_team, {})
    end
end
