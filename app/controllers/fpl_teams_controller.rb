class FplTeamsController < ApplicationController
  before_action :set_fpl_team, only: [:show, :edit, :update, :destroy]

  # GET /fpl_teams
  # GET /fpl_teams.json
  def index
    @fpl_teams = FplTeam.all
  end

  # GET /fpl_teams/1
  # GET /fpl_teams/1.json
  def show
  end

  # GET /fpl_teams/new
  def new
    @fpl_team = FplTeam.new
  end

  # GET /fpl_teams/1/edit
  def edit
  end

  # POST /fpl_teams
  # POST /fpl_teams.json
  def create
    @fpl_team = FplTeam.new(fpl_team_params)

    respond_to do |format|
      if @fpl_team.save
        format.html { redirect_to @fpl_team, notice: 'Fpl team was successfully created.' }
        format.json { render :show, status: :created, location: @fpl_team }
      else
        format.html { render :new }
        format.json { render json: @fpl_team.errors, status: :unprocessable_entity }
      end
    end
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
