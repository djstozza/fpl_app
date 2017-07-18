class WaiverPicksController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team_list
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
    in_player = Player.find_by(id: params[:target_id])
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: @fpl_team_list,
      list_position: list_position,
      in_player: in_player,
      current_user: current_user
    )

    respond_to do |format|
      if form.save
        waiver_picks_decorator = WaiverPicksDecorator.new(
          @fpl_team_list.waiver_picks
        )
        format.json do
          render json: {
            success: 'Waiver pick was successfully created.',
            waiver_picks: waiver_picks_decorator.all_data
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
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: @fpl_team_list,
      waiver_pick: @waiver_pick,
      new_pick_number: params[:new_pick_number],
      current_user: current_user
    )
    respond_to do |format|
      if form.save
        format.json do
          render json: {
            success: 'Waiver picks successfully re-ordered',
            waiver_picks: WaiverPicksDecorator.new(
              @fpl_team_list.waiver_picks
            ).all_data
          }
        end
      else
        format.json { render json: form.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fpl_teams/1/waiver_picks/1
  # DELETE /fpl_teams/1/waiver_picks/1.json
  def destroy
    form = ::FplTeams::DeleteWaiverPickForm.new(
      fpl_team_list: @fpl_team_list,
      waiver_pick: @waiver_pick,
      current_user: current_user
    )
    respond_to do |format|
      if form.save
        format.json do
          render json: {
            success: 'Waiver pick successfully deleted.',
            waiver_picks: WaiverPicksDecorator.new(
              @fpl_team_list.waiver_picks
            ).all_data
          }
        end
      else
        format.json { render json: form.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waiver_pick
      @waiver_pick = WaiverPick.find(params[:id])
    end

    def set_fpl_team_list
      @fpl_team_list = FplTeamList.find_by(id: params[:fpl_team_list_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def waiver_pick_params
      params.fetch(:waiver_pick, {})
    end
end
