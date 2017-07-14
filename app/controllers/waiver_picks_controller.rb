class WaiverPicksController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team
  before_action :set_waiver_pick, only: [:show, :edit, :update, :destroy]

  # GET /fpl_teams/1/waiver_picks
  # GET /fpl_teams/1/waiver_picks.json
  def index
    @waiver_picks = WaiverPick.all
  end

  # GET /fpl_teams/1/waiver_picks/1
  # GET /fpl_teams/1/waiver_picks/1.json
  def show
  end

  # GET /fpl_teams/1/waiver_picks/new
  def new
    @waiver_pick = WaiverPick.new
  end

  # GET /fpl_teams/1/waiver_picks/1/edit
  def edit
  end

  # POST /fpl_teams/1/waiver_picks
  # POST /fpl_teams/1/waiver_picks.json
  def create
    list_position = ListPosition.find_by(id: params[:list_position_id])
    list_position_player_name = list_position.player.name
    target = Player.find_by(id: params[:target_id])
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team: @fpl_team,
      list_position: list_position,
      target: target,
      current_user: current_user
    )

    respond_to do |format|
      if form.save
        format.json do
          render json: {
            success: 'Waiver pick was successfully created.',
            waiver_picks: @fpl_team.waiver_picks.where(round: list_position.fpl_team_list.round)
          }
        end
      else
        format.json { render json: form.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fpl_teams/1/waiver_picks/1
  # PATCH/PUT /fpl_teams/1/waiver_picks/1.json
  def update
    respond_to do |format|
      if @waiver_pick.update(waiver_pick_params)
        format.html { redirect_to @waiver_pick, notice: 'Waiver pick was successfully updated.' }
        format.json { render :show, status: :ok, location: @waiver_pick }
      else
        format.html { render :edit }
        format.json { render json: @waiver_pick.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fpl_teams/1/waiver_picks/1
  # DELETE /fpl_teams/1/waiver_picks/1.json
  def destroy
    @waiver_pick.destroy
    respond_to do |format|
      format.html { redirect_to waiver_picks_url, notice: 'Waiver pick was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waiver_pick
      @waiver_pick = WaiverPick.find(params[:id])
    end

    def set_fpl_team
      @fpl_team = FplTeam.find_by(id: params[:fpl_team_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def waiver_pick_params
      params.fetch(:waiver_pick, {})
    end
end
