class FplTeamListsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team_list, only: [:show, :update]

  # GET /fpl_team_lists/1
  # GET /fpl_team_lists/1.json
  def show
    respond_to do |format|
      format.json do
        render json: {
          line_up: ListPositionsDecorator.new(@fpl_team_list.list_positions).list_position_arr,
          editable: @fpl_team_list.round.id == RoundsDecorator.new(Round.all).current_round.id
        }
      end
    end
  end

  # PATCH/PUT /fpl_team_lists/1
  # PATCH/PUT /fpl_team_lists/1.json
  def update
    player = Player.find_by(id: params[:player_id])
    target = Player.find_by(id: params[:target_id])
    form = ::FplTeams::ProcessSubstitutionForm.new(
      fpl_team_list: @fpl_team_list,
      player: player,
      target: target,
      current_user: current_user
    )
    respond_to do |format|
      if form.save
        format.json do
          render json: {
            line_up: ListPositionsDecorator.new(@fpl_team_list.list_positions).list_position_arr,
            success: "Successfully substituted #{player.name} with #{target.name}."
          }
        end
      else
        format.json { render json: form.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fpl_team_list
      @fpl_team_list = FplTeamList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fpl_team_list_params
      params.fetch(:fpl_team_list, {})
    end
end
