class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy]
  before_action :set_fpl_team, only: [:edit, :update]
  before_action :authenticate_user!

  # GET /leagues
  # GET /leagues.json
  def index
    @leagues = current_user.leagues
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    respond_to do |format|
      format.html
      format.json do
        render json: {
          league: @league,
          fpl_teams: @league.fpl_teams,
          users: @league.users,
          commissioner: @league.commissioner,
          current_user: current_user
        }
      end
    end
  end

  # GET /leagues/new
  def new
    @form = Leagues::ProcessLeagueForm.new(
      league: League.new,
      fpl_team: FplTeam.new,
      current_user: current_user
    )
  end

  # GET /leagues/1/edit
  def edit
    # fpl_team = FplTeam.find_by(league: @league, user: current_user)
    @form = Leagues::ProcessLeagueForm.new(league: @league, fpl_team: @fpl_team, current_user: current_user)
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @form = Leagues::ProcessLeagueForm.new(
      league: League.new,
      fpl_team: FplTeam.new,
      current_user: current_user
    )
    @form.attributes = league_params
    respond_to do |format|
      if @form.save
        format.html { redirect_to @form.league, notice: 'League was successfully created.' }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leagues/1
  # PATCH/PUT /leagues/1.json
  def update
    @form = Leagues::ProcessLeagueForm.new(league: @league, fpl_team: @fpl_team, current_user: current_user)
    @form.attributes = league_params
    respond_to do |format|
      if @form.update
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    @league.destroy
    respond_to do |format|
      format.html { redirect_to leagues_url, notice: 'League was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_league
    @league = League.find(params[:id])
  end

  def set_fpl_team
    @fpl_team = FplTeam.find_by(league: @league, user: current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def league_params
    params.permit(:id, :league_name, :code, :comissioner_id, :fpl_team_name, :user_id)
  end
end
