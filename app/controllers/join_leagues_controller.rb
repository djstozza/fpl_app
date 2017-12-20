class JoinLeaguesController < ApplicationController
  before_action :authenticate_user!

  # GET /join_leagues/new
  def new
    @form = Leagues::JoinLeagueForm.new(current_user: current_user)
  end

  # POST /join_leagues
  # POST /join_leagues.json
  def create
    @form = Leagues::JoinLeagueForm.run(join_league_params.merge(current_user: current_user))
    respond_to do |format|
      if @form.valid?
        format.html { redirect_to @form.league, notice: 'League was successfully joined.' }
        format.json { render :show, status: :created, location: @league }
      else
        flash[:danger] = @form.errors[:base]&.first
        format.html { render :new }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def join_league_params
    params.fetch(:fpl_team, keys: [:code, :league_name, :fpl_team_name])
  end
end
