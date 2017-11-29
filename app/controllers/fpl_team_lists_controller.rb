class FplTeamListsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team_list, only: [:show, :update]
  before_action :set_fpl_team, only: [:index, :show, :update]
  respond_to :json

  # GET /fpl_teams/1/fpl_team_lists
  # GET /fpl_teams/1/fpl_team_lists.json
  def index
    render json: fpl_team_list_hash
  end

  # GET /fpl_team_lists/1
  # GET /fpl_team_lists/1.json
  def show
    render json: fpl_team_list_hash
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

    if form.save
      render json: fpl_team_list_hash.merge!(success: "Successfully substituted #{player.name} with #{target.name}.")
    else
      render json: fpl_team_list_hash.merge!(errors: form.errors.full_messages), status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_fpl_team_list
    @fpl_team_list = FplTeamList.find(params[:id])
  end

  def set_fpl_team
    @fpl_team = FplTeam.find_by(id: params[:fpl_team_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def fpl_team_list_params
    params.fetch(:fpl_team_list, {})
  end

  def fpl_team_list_hash
    fpl_team_decorator = FplTeamDecorator.new(@fpl_team)
    fpl_team_list_decorator = FplTeamListDecorator.new(@fpl_team_list || fpl_team_decorator.current_fpl_team_list)
    rounds_decorator = fpl_team_decorator.fpl_team_list_rounds
    line_up = if @fpl_team_list
                ListPositionsDecorator.new(@fpl_team_list.list_positions).list_position_arr
              else
                fpl_team_decorator.current_line_up
              end
    {
      rounds: rounds_decorator,
      round: fpl_team_list_decorator.round,
      fpl_team_lists: fpl_team_decorator.fpl_team_lists.order(:round_id),
      fpl_team_list: fpl_team_list_decorator,
      line_up: line_up,
      status: Round.round_status(round: fpl_team_list_decorator.round),
      unpicked_players: LeagueDraftPicksDecorator.new(@fpl_team.league).unpicked_players,
      score: fpl_team_list_decorator.score
    }
  end
end
