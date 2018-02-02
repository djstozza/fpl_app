class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy]
  before_action :set_fpl_team, only: [:edit, :update]
  before_action :authenticate_user!

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    league_decorator = LeagueDraftPicksDecorator.new(@league)
    respond_to do |format|
      format.html
      format.json do
        render json: {
          league: league_decorator,
          fpl_teams: league_decorator.fpl_teams,
          users: league_decorator.users,
          commissioner: league_decorator.commissioner,
          picked_players: league_decorator.picked_players,
          unpicked_players: league_decorator.unpicked_players,
          fpl_team_list_arr: league_decorator.fpl_team_list_arr,
          current_user: current_user
        }
      end
    end
  end

  # GET /leagues/new
  def new
    @form = Leagues::CreateLeagueForm.new(
      league: League.new,
      fpl_team: FplTeam.new,
      current_user: current_user
    )
  end

  # GET /leagues/1/edit
  def edit
    @form = Leagues::ProcessLeagueForm.new(league: @league, current_user: current_user)
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @form = Leagues::CreateLeagueForm.run(league_params.merge(current_user: current_user))

    respond_to do |format|
      if @form.valid?
        format.html { redirect_to @form.league, notice: 'League was successfully created.' }
        format.json { render :show, status: :created, location: @league }
      else
        flash[:danger] = @form.errors[:base]&.first
        format.html { render :new }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leagues/1
  # PATCH/PUT /leagues/1.json
  def update
    @form = Leagues::ProcessLeagueForm.run(league_params.merge(current_user: current_user))

    respond_to do |format|
      if @form.valid?
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        flash[:danger] = @form.errors[:base]&.first
        format.html { render :edit }
        format.json { render json: @form.errors, status: :unprocessable_entity }
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
    params.fetch(:league, keys: [:id, :code, :league_name, :fpl_team_name])
  end
end
