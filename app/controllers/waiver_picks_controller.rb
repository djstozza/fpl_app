class WaiverPicksController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team
  before_action :set_fpl_team_list
  before_action :set_waiver_pick, only: [:show, :edit, :update, :destroy]

  # GET /fpl_teams/1/waiver_picks
  # GET /fpl_teams/1/waiver_picks.json
  def index
    waiver_picks_decorator = WaiverPicksDecorator.new(
      @fpl_team.waiver_picks.where(round_id: (params[:round_id] || Round.current_round.id))
    )
    respond_to do |format|
      format.json { render json: { waiver_picks: waiver_picks_decorator.all_data } }
    end
  end

  # POST fpl_teams/1/fpl_team_lists/1/waiver_picks
  # POST fpl_teams/1/fpl_team_lists/1/waiver_picks.json
  def create
    outcome = ::FplTeams::CreateWaiverPickForm.run(
      params.merge(current_user: current_user, fpl_team_list: @fpl_team_list, fpl_team: @fpl_team)
    )

    respond_to do |format|
      if outcome.valid?
        waiver_pick = outcome.waiver_picks.last
        format.json do
          render json: {
            success: "Waiver pick was successfully created. Pick number: #{waiver_pick.pick_number}, " \
                        "In: #{waiver_pick.in_player.name}, Out: #{waiver_pick.out_player.name}",
            waiver_picks: WaiverPicksDecorator.new(@fpl_team_list.waiver_picks).all_data
          }
        end
      else
        format.json do
          render json: {
            errors: outcome.errors.full_messages,
            waiver_picks: WaiverPicksDecorator.new(@fpl_team_list.waiver_picks).all_data
          }, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT fpl_teams/1/fpl_team_lists/1/waiver_picks/1
  # PATCH/PUT fpl_teams/1/fpl_team_lists/1/waiver_picks/1.json
  def update
    outcome = ::FplTeams::UpdateWaiverPickOrderForm.run(
      params.merge(
        current_user: current_user,
        fpl_team_list: @fpl_team_list,
        fpl_team: @fpl_team,
        waiver_pick: @waiver_pick
      )
    )
    respond_to do |format|
      if outcome.valid?
        format.json do
          render json: {
            success: "Waiver picks successfully re-ordered. Pick number: #{@waiver_pick.pick_number}, In: " \
                        "#{@waiver_pick.in_player.name}, Out: #{@waiver_pick.out_player.name}",
            waiver_picks: WaiverPicksDecorator.new(@fpl_team_list.waiver_picks).all_data
          }
        end
      else
        format.json do
          render json: {
            errors: outcome.errors.full_messages,
            waiver_picks: WaiverPicksDecorator.new(@fpl_team_list.waiver_picks).all_data
          }, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE fpl_teams/1/fpl_team_lists/1/waiver_picks/1
  # DELETE fpl_teams/1/fpl_team_lists/1/waiver_picks/1.json
  def destroy
    outcome = ::FplTeams::DeleteWaiverPickForm.run(
      params.merge(
        fpl_team: @fpl_team,
        fpl_team_list: @fpl_team_list,
        waiver_pick: @waiver_pick,
        current_user: current_user
      )
    )

    respond_to do |format|
      if outcome.valid?
        format.json do
          render json: {
            success: "Waiver pick successfully deleted. Pick number: #{@waiver_pick.pick_number}, In: " \
                        "#{@waiver_pick.in_player.name}, Out: #{@waiver_pick.out_player.name}",
            waiver_picks: WaiverPicksDecorator.new(@fpl_team_list.waiver_picks).all_data
          }
        end
      else
        format.json do
          render json: {
            errors: outcome.errors.full_messages,
            waiver_picks: WaiverPicksDecorator.new(@fpl_team_list.waiver_picks).all_data
          }, status: :unprocessable_entity
        end
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

  def set_fpl_team
    @fpl_team = FplTeam.find_by(id: params[:fpl_team_id])
  end
end
